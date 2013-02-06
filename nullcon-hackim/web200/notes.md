		$.ajax({
			type: "POST",
			url: "view.php",
			data: "View=View&id="+1,
			success: function(msg){
				alert(msg);
			}
		});
