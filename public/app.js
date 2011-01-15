var showed = false

$(document).ready(function(){
    $("#show_correct").click(function(){
        if(showed){
            $(".correct_show").removeClass("correct_show")
            $(this).val("Pokaż poprawne odpowiedzi")
        } else {
            $(".correct").addClass("correct_show")
            $(this).val("Ukryj poprawne odpowiedzi")
        }
        
        showed = !showed
    })
    
    $("#check_score").click(function(){
        var questions = $("%ul.ts > li")
        var j = 0
        questions.each(function(i,e){
            if(check(e)) j++;
        })
        
        $(".score").text("Wynik: " + j + " / " + questions.size())
        
    })
})

function XOR(a,b) {
  return (a || b) && !(a && b);
}

function check(e){
    var x = true
    var e = $(e)
    e.removeClass("good")
    e.removeClass("bad")
    
    e.find("input[type=checkbox]").each(function(i,c){
        var a = $(c).parent().hasClass("correct")
        var b = c.checked
        
        console.log(a + " " + b + " " + ((a && !b) || (!a && b)))
        
        if((a && !b) || (!a && b)) {
            x = false
            return false;
        }
    })
    
    if(x) e.addClass("good")
    else e.addClass("bad")
        
    return x;
}