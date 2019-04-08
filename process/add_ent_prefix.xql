xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace app="http://www.digital-archiv.at/ns/aratea-digital/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/aratea-digital/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";


for $x in collection($app:data)//tei:rs[@type='org' and @ref]
    let $old_ref := substring-after(data($x/@ref), '#')
    let $new_ref := "#org"||$old_ref
(:    let $remove := update delete $x/@ref:)
(:    let $add := update insert attribute ref {$new_ref} into $x:)
    return 
        $new_ref