<?php
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
// Create connection
$conn = new mysqli('localhost', 'root','root','library' );

// Check connection
if ($conn -> connect_error){
   die("Connection failed:". $conn->connect_error);
}

?>

<?php
date_default_timezone_set(New_York);
?>

<?php
$to_insert = '';
$books =isset($_POST['book'])?$_POST['book']:[];
$member_id = $_POST['member_id'];

foreach($books as $copyid => $should_checkout){
    $sql = "INSERT INTO CheckedOut (copyid, mid,checkoutDate, dueDate, status)
VALUES (?, ?, ?, ?, ?)";



    $query = $conn->prepare($sql);
    $status = "Holding";
    $checkoutDate = date("Y-m-d H:i:s");
//    echo $checkoutDate;

    $date = strtotime(date("Y-m-d H:i:s", strtotime($checkoutDate)) . " +3month");
//    echo $date;

    $dueDate = date("Y-m-d H:i:s",$date);
//    echo $dueDate;

    $query->bind_param('sssss', $copyid, $member_id, $checkoutDate, $dueDate, $status);

    $query->execute();
}

?>
<h2>Book you currently holding:</h2>
<?php
//select member's holding book
$query = $conn ->prepare("select b.bookid, bc.copyid, b.booktitle, c.dueDate
from Book b inner join BookCopy bc  inner join CheckedOut c inner join
 (select copyid, max(checkoutDate) as MaxDate from CheckedOut group by copyid
 )B
 on c.copyid = B.copyid and b.bookid = bc.bookid and bc.copyid = c.copyid and c.checkoutDate = B.MaxDate
 where c.status in('Holding' ,'Overdue') and c.mid = ?
 ");


$query->bind_param('s', $member_id);
$query->execute();
$result = $query->get_result();

if ($result ->num_rows >0){
    //return the info of holding book
    while($row = $result -> fetch_assoc()){
        echo  "<br>" . " Book title: " . $row['booktitle']."<br>" .  " Copy id: " . $row["copyid"].
            "<br>" . " Due Date: " . $row["dueDate"] . "<br>";
    }
}
else{
    echo "Book cleared";
}




?>
