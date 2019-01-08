xquery version "3.1";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";
import module namespace app="http://www.digital-archiv.at/ns/aratea-digital/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/aratea-digital/config" at "modules/config.xqm";
declare option exist:serialize "method=json media-type=text/javascript content-type=application/json";


let $description := doc(concat($config:app-root, "/repo.xml"))//repo:description/text()
let $authors := normalize-space(string-join(doc(concat($config:app-root, "/repo.xml"))//repo:author//text(), ', '))
let $map := map{
    "title": "aratea-digital",
    "subtitle": "A collection of digital editions and manuscript descriptions of medieval transmissions of Aratus‘ (ca. 315/310-240 BC) didactic poem the Phaenomena",
    "author": "Peter Andorfer, Ivana Dobcheva",
    "description": "Aratea Digital is a database collecting information about astronomy in the Early Middle Ages. The main focus of the project is the Latin transmission of the so-called Aratea texts including the Latin translations and the derivative texts based on Aratus' didactic poem Phaenomena. The website presents descriptions of their (pre-13th-century) manuscripts, references to the latest editions and relevant literature.",
    "github": "https://github.com/ivanadob/aratea-app",
    "purpose_de": "Ziel von aratea-digital ist die Publikation von Forschungsdaten.",
    "purpose_en": "The purpose of aratea-digital is the publication of research data.",
    "app_type": "digital-edition",
    "base_tech": "eXist-db",
    "framework": "Digital Scholarly Editions Base Application"
}
return 
        $map