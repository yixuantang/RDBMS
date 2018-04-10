<?php

// Create connection
$conn = new mysqli('localhost', 'root','root','library' );
// Enables or disables internal report functions
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$is_authorized = false;
if($member_id = $_REQUEST['member_id']) {

    $query = $conn->prepare("SELECT * FROM Member WHERE mid = ?");
    $query->bind_param('s', $member_id);

    // run query and get result
    $query->execute();
    $res = $query->get_result();
    $row = $res->fetch_assoc();

    // check member id
    if($member_id == $row['mid']){
        $is_authorized = true;
    }
}

?>

<html>
<head></head>
<body>

<div id='results'>
    <?php

    if(!$is_authorized){
        ?> <h1>Invalid Member ID</h1> <?php
    }
    else {
        // prepare statement (to avoid sql injection)
        $query = $conn->prepare("
select A.* from 
(
  select b.*, sd.status, bc.copyid from Book b 
  inner join BookCopy bc on b.bookid = bc.bookid
  left join 
  (
    select c.* from CheckedOut c 
    inner join 
    (
      select copyid, mid, max(checkoutDate) as maxDate 
      from CheckedOut group by copyid
    ) B on c.copyid = B.copyid and c.checkoutDate = B.maxDate
  ) sd on bc.copyid = sd.copyid
where sd.status = 'Returned' or sd.status is NULL
)A
where A.booktitle like ? or A.category like ?
");
// $_POST collect the input value from method = "POST" in HTML file
        $q = '%'.($_POST['search']?:'').'%';
        $query->bind_param('ss', $q, $q);

        // run query and get result
        $query->execute();
        $result = $query->get_result();

        ?>
        <form action="checkout-1.php" method="post">
        <p>key word: <?= $_POST['search']?></p>
        <?php
        if ($result ->num_rows >0) {
            while ($book = $result->fetch_assoc()) {
                ?>
                <h3>
                    <input type="checkbox" name='book[<?= $book['copyid'] ?>]'>

                    <?= $book['bookid'] ?>
                    <?= $book['booktitle'] ?>
                </h3>

                <p>Copyid: <?= $book['copyid'] ?>
                <p>Category: <?= $book['category'] ?></p>
                <p>Author: <?= $book['author'] ?></p>
                Publish Date: <?= $book['publishdate'] ?>

                </p>
                <?php
            }
        }
        else{
            echo "No Book Available<br>"; //key word leads to no result or no book left.
        }

        ?>
        <input type='hidden' name='member_id' value='<?= $member_id ?>'>

        <input type="submit" value = "Check Out">
        </form><?php
    }

    ?>
</div>
</body>
</html>

