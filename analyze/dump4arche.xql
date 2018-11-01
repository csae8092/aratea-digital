xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/aratea-digital/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/aratea-digital/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace acdh="https://vocabs.acdh.oeaw.ac.at/schema#";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace util = "http://exist-db.org/xquery/util";

declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

let $about := doc($app:data||'/project.rdf')/rdf:RDF
let $project := $about//acdh:Project[1]
let $topCollection := $about//acdh:Collection[not(acdh:isPartOf)]
let $childCollections := $about//acdh:Collection[acdh:isPartOf]
let $RDF := 
    <rdf:RDF
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
        xmlns:acdhi="https://id.acdh.oeaw.ac.at/"
        xmlns:foaf="http://xmlns.com/foaf/spec/#"
        xml:base="https://id.acdh.oeaw.ac.at/">
            {$project}
            {$topCollection}
            {$childCollections}
            {
            for $x in $childCollections
                let $collID := data($x/@rdf:about)
                let $collName := tokenize($collID, '/')[last()]
                let $collection-uri := $app:data||'/'||$collName
                let $document-names := xmldb:get-child-resources($collection-uri)
                for $doc in $document-names
                let $resID := string-join(($collection-uri, $doc), '/')
                let $node := try {
                        doc($resID)
                    } catch * {
                        false()
                    }
                let $title := try {
                        <acdh:hasTitle>{normalize-space(string-join($node//tei:titleStmt/tei:title//text(), ' '))}</acdh:hasTitle>
                    } catch * {
                        <acdh:hasTitle>{$doc}</acdh:hasTitle>
                    }return
                    <acdh:Resource rdf:about="{string-join(($collID, $doc), '/')}">
                        {$title}
                        <acdh:hasAuthor>
                            <acdh:Person rdf:about="https://orcid.org/0000-0003-2388-1114"/>
                        </acdh:hasAuthor>
                        <acdh:isPartOf rdf:resource="{$collID}"/>
                    </acdh:Resource>
        }

    </rdf:RDF>
    
return
    $RDF