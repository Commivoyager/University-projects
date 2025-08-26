<?php
    $page_content = "";
    $page_link = "";
    //checking whether the required GET request has been received
    if(isset($_GET["link"])){
        $link_id = $_GET["link"];
        //to change the color of the link, it is necessary
        //to find out which page the user is navigating to
        switch($link_id){
            case "guitarists-link":
                $page_link .= "guitarists.html";
                break;
            case "guitars-link":
                $page_link .= "guitars.html";
                break;
            case "index-link":
                $page_link .= "index.html";
                break;
            case "site-map-link":
                $page_link .= "sitemap.html";
                break;
            case "suggestions-link":
                $page_link .= "suggestions.html";
                break;
        }
        //taking the html code of the page for subsequent modification and output
        $page_content = file_get_contents($page_link);
        //setting the necessary properties for the link background color
        $new_link_style = "#" . $link_id. "{ background-color: white; }";
        //replacing the commented out part of the style tag to set the required style
        $page_content = str_replace("/*link-styles*/", $new_link_style, $page_content);
        //output of page content
        echo $page_content;
    }