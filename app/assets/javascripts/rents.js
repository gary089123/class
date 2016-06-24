$(function(){
    setInterval(flicker,800);
});
function flicker(){
    $('.btn').addClass('active',400)
    $('.btn').removeClass('active',400);
    //$('.btn').fadeOut(1000).fadeIn(1000);
}
