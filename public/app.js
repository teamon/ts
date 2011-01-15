var showed = false

$(document).ready(function(){
    $("#show_correct").click(function(){
        if(showed){
            $(".correct_show").removeClass("correct_show")
            $(this).val("Pokaż poprawne odpowiedzi")
        } else {
            $(".correct").addClass("correct_show")
            $(this).val("Ukryj poprawne odpowiedzi")
            $(".question input[type=text]").each(function(i,e){
                $(e).val($(e).attr("rel"));
            })
        }
        
        showed = !showed
    })
    
    $("#check_score").click(function(){
        var questions = $(".question")
        var j = 0
        questions.each(function(i,e){
            if(check(e)) j++;
        })
        
        $(".score").text("Wynik: " + j + " / " + questions.size())
    })
})

function XOR(a,b){
    return (a && !b) || (!a && b)
}

function check(e){
    var x = true
    var e = $(e)
    e.removeClass("good")
    e.removeClass("bad")
    
    e.find("input[type=checkbox]").each(function(i,c){
        if(XOR($(c).parent().hasClass("correct"), c.checked)) {
            x = false
            return false;
        }
    })
    
    e.find("option").each(function(i,c){
        if(XOR($(c).hasClass("correct"), c.selected)) {
            x = false
            return false;
        }
    })
    
    e.find("input[type=text]").each(function(i,c){
        if(XOR($(c).val(), $(c).attr("rel"))) {
            x = false
            return false;
        }
    })
    
    if(x) e.addClass("good")
    else e.addClass("bad")
        
    return x;
}