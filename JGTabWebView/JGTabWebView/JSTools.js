function getSourceAtPoint(x,y) {
    var image = "";
    var link = "";
    var e = document.elementFromPoint(x,y);
    while (e) {
        if (e.src) {
            image = 'image:"' + e.src + '"';
        }
        
        if (e.href) {
            link = '"link":"' + e.href + '"';
            break;
        }

        e = e.parentNode;
    }
    
    if (!link && !image) {
        return ""
    }
    
    var json = "{";
    if(link) {
        json += link;
    }
    if(image) {
        if (link) {
            json += ',';
        }
        json += image;
    }
    json += '}';
    return json;
}
