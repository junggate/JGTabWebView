function getSourceAtPoint(x,y) {
    var image = "";
    var link = "";
    var e = document.elementFromPoint(x,y);
    var children = e.childNodes;
    for (var i = 0; i < children.length; i++)
    {
        var child = children[i]
        if (child.src) {
            image = '"image":"' + child.src + '"';
        }

        if (child.href) {
            link = '"link":"' + child.href + '"';
        }
    };

    while (e) {
        if (e.src) {
            image = '"image":"' + e.src + '"';
        }
        
        if (e.href) {
            link = '"link":"' + e.href + '"';
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
