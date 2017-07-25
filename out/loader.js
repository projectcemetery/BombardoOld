function loadGame () {
    var loaderCanvas = document.getElementById('loader'); 
    loaderCanvas.width = loaderCanvas.parentElement.clientWidth;
    loaderCanvas.height = loaderCanvas.parentElement.clientHeight;
    var ctx = loaderCanvas.getContext ('2d');
    var isLoading = true;
    var width = loaderCanvas.width;
    var height = loaderCanvas.height;
    var centerx = width / 2;
    var centery = height / 2;

    var angle = 0.0;    
    var pos = 0;
    var kpos = 1;

    
    function drawAnimation () {
        if (!isLoading) return;
        ctx.fillStyle = "#000000";
        ctx.fillRect(0,0,width,height);

        for (var i = 0; i < 50; i++) {
            ctx.save();
            ctx.translate (centerx, centery);
            ctx.rotate ((angle - i*4) * 3.14 / 180);
            ctx.beginPath();
            ctx.arc(0, -45, 6 - i / 10,0,2*Math.PI);            
            var s = "hsla(" + 120 + i * pos / 10  + ", " + pos + "%, 50%, 0.9)";
            ctx.fillStyle = s;
            ctx.fill();
            ctx.restore ();

            pos += 0.01 * kpos;
            if (pos > 100) kpos = -1;
            if (pos < 1) kpos = 1;
        }

        angle += 2;
        if (angle > 360) angle = 0;        

        window.requestAnimationFrame(drawAnimation);
    }

    function loadAll () {
        var req = new XMLHttpRequest();
        req.open("GET", "/pack.zip");
        req.responseType = "arraybuffer";

        req.onload = function (e) {
            var resp = req.response;
            document.packCache = {
                name : "pack.zip",
                data : resp
            }

            var req2 = new XMLHttpRequest();
            req2.open("GET", "/main.js");
            req2.onload = function (e2) {
                window.setTimeout (function() {                
                    eval (req2.responseText);
                    setTimeout (function() {
                        isLoading = false;
                        loaderCanvas.remove ();
                        var game = document.getElementById("webgl");    
                        game.style.display = "block";
                    }, 2000);                    
                }, 4000);
            };

            req2.send ();
        };

        req.send ();
    }

    drawAnimation ();
    loadAll ();
}

document.addEventListener("DOMContentLoaded", function () {
    loadGame ();
});