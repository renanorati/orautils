// metodo para iniciar scripts
function loadScript(url, callback){

    var script = document.createElement("script")
    script.type = "text/javascript";

    if (callback && typeof callback === "function") {
        if (script.readyState){  //IE
            script.onreadystatechange = function(){
                if (script.readyState == "loaded" ||
                        script.readyState == "complete"){
                    script.onreadystatechange = null;
                    callback();
                }
            };
        } else {  //Others
            script.onload = callback;
        }
    }

    script.src = url;
    document.getElementsByTagName("head")[0].appendChild(script);
}
function loadCSS(url, callback){

    var link = document.createElement("link")
    link.type = "text/css";
    link.rel = "stylesheet";

    if (callback && typeof callback === "function") {
        if (link.readyState){  //IE
            link.onreadystatechange = function(){
                if (link.readyState == "loaded" ||
                        link.readyState == "complete"){
                    link.onreadystatechange = null;
                    callback();
                }
            };
        } else {  //Others
            link.onload = callback;
        }
    }

    link.href = url;
    document.getElementsByTagName("head")[0].appendChild(link);
}
// carregando estilos iniciais
loadCSS('prettify.css');
loadCSS('style-plsql.css');
// carregando bibliotecas iniciais
loadScript('prettify.js',
           function () { loadScript('lang-plsql2.js', prettyPrint); });