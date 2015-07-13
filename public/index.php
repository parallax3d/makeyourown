<? 
require($_SERVER["DOCUMENT_ROOT"] . "/bitrix/header.php"); 
$APPLICATION->SetTitle("Редактор украшений");
?>

   
    <link rel=stylesheet href=css/jquery-ui-1.10.3.custom.css>
    <link rel=stylesheet href=css/jquery-selectBoxIt.css>
    <link rel=stylesheet type=text/css href=css/main.css>

 	<div class="main-content" id="editor">
        <div id="no-webgl">
            <h1>Ваш браузер не поддерживает WebGL</h1>
        </div>
       
<?
// $arModels = array(2,4,6,7);


// нужно найти информацию о модели
if( CModule::IncludeModule('iblock') ){
    
    $arFilter = array('ACTIVE' => 'Y','IBLOCK_ID' => 7,'!COMING_SOON'=>"Y");
    $arOrder = array('SORT'=>'ASC');
    $arSelect = array('NAME','PREVIEW_PICTURE','PREVIEW_TEXT','PROPERTY_MODEL_ID');

    $ModelRes = CIBlockElement::GetList($arOrder, $arFilter, false, false,$arSelect);
    
    while($ModelData = $ModelRes->Fetch()){
        $image = CFILE::ResizeImageGet($ModelData['PREVIEW_PICTURE'],array('width' => 70,'height' => 70 ), BX_RESIZE_IMAGE_PROPORTIONAL,true );  
        $ModelData['IMAGE'] = $image['src'];
        $arModels[$ModelData['PROPERTY_MODEL_ID_VALUE']] = $ModelData;
    }

}
// картинки не уменьшаются!!!
// print_r($arModels);
?>


       <div class="menu-wrapper">
	        <div id="menu">
	            <ul class="menu-list">
		            <?foreach ($arModels as $modelId => $modelItem) :?>
		            	<li>
		                    <a pid="p<?=$modelId?>" title="Diamond ring" href="#<?=$modelId?>">
		                        <div style="background-image: url(<?=$modelItem['IMAGE']?>)" class="menu-img"></div>
		                    </a>
		                </li>
		            <?endforeach;?>
	                <?/*
	                <li>
	                    <a pid=p1 title="Diamond ring" href=#1>
	                        <div style="background-image: url(css/icons/product1.png)" class=menu-img></div>
	                    </a>
	                </li>
	                <li>
	                    <a pid=p2 title=M-Ring href=#2>
	                        <div style="background-image: url(css/icons/product2.png)" class=menu-img></div>
	                    </a>
	                </li>
	                <li>
	                    <a pid=p3 title=Messager href=#3>
	                        <div style="background-image: url(css/icons/product4.png)" class=menu-img></div>
	                    </a>
	                </li>
	                <li>
	                    <a pid=p4 title=Necklace href=#4>
	                        <div style="background-image: url(css/icons/product5.png)" class=menu-img></div>
	                    </a>
	                </li>
	                <li>
	                    <a pid=p5 title=Raw href=#5>
	                        <div style="background-image: url(css/icons/product6.png)" class=menu-img></div>
	                    </a>
	                </li>
	                <li>
	                    <a pid=p6 title=Raw-Round href=#6>
	                        <div style="background-image: url(css/icons/product7.png)" class=menu-img></div>
	                    </a>
	                </li>
	                <li>
	                    <a pid=p7 title=Cufflink href=#7>
	                        <div style="background-image: url(css/icons/product8.png)" class=menu-img></div>
	                    </a>
	                </li>
	                */?>
	            </ul>
	        </div>
	    </div>


        <div class="center cont-wrapper">
            <div id="cont">
                <div id="ajax-loading"></div>
            </div>

            <div class="move-line">
            	<div>&uarr;</div>
            	<div class="dot"></div>
            	<div>&darr;</div>

            </div>

            <form action="" method=POST>
                <div id="panel"></div>
            </form>
        </div>

        <?if(is_object($USER) && $USER->isAdmin()):?>
        	<p class=stl onclick=exportSTL()>Скачать STL</p>
        <?endif;?>
    </div>
        
        <script type=text/javascript src=js/jsdiff.js></script>
        <script type=text/javascript src=js/jquery.min.js></script>
        <script type=text/javascript src=js/jqueryui.js></script>
        <script type=text/javascript src=js/three.js></script>
        <script type=text/javascript src=js/BoundingBoxHelper.js></script>
        <script type=text/javascript src=js/stl.js></script>
        <script type=text/javascript src=js/obj.js></script>
        <script type=text/javascript src=js/orbit.js></script>
        <script type=text/javascript src=js/detector.js></script>
        <script type=text/javascript src=js/filesaver.js></script>
        <script type=text/javascript src=js/main.js></script>
        <script type=text/javascript src=js/config.js></script>
        <script type=text/javascript src=js/fonts/damion.typeface.js></script>
        <script type=text/javascript src=js/fonts/molle.typeface.js></script>
        <script type=text/javascript src=js/fonts/yellowtail.typeface.js></script>
        <script type=text/javascript src=js/fonts/arian_amu.typeface.js></script>
        <script type=text/javascript src=js/fonts/red_october.typeface.js></script>
        <script type=text/javascript src=js/fonts/fha_nicholson_french_ncv.typeface.js></script>
        <script type=text/javascript src=js/fonts/american_captain.typeface.js></script>
        <script type=text/javascript src=js/fonts/scada.typeface.js></script>
        <script type=text/javascript src=js/fonts/calligraph.typeface.js></script>
        <script type=text/javascript src=js/fonts/aldrich.typeface.js></script>
        <script type=text/javascript src=js/fonts/icomoon.typeface.js></script>
        <script type=text/javascript src=js/fonts/bolero_script.typeface.js></script>
        <script type=text/javascript src=js/fonts/good_vibes.typeface.js></script>
        <script type=text/javascript src=js/fonts/bold_regular.typeface.js></script>
        <script type=text/javascript src=js/fonts/campanella_regular.typeface.js></script>
        <script type=text/javascript src=js/fonts/cyrillic_ribbon.typeface.js></script>
        <script type=text/javascript src=js/fonts/heinrich_script.typeface.js></script>
        <script type=text/javascript src=js/fonts/park_avenue.typeface.js></script>
        <script type=text/javascript src=js/fonts/parsek_cyrillic.typeface.js></script>
        <script type=text/javascript src=js/fonts/teddy_bear.typeface.js></script>
        <script type=text/javascript src=js/fonts/andantino_script.typeface.js></script>
        <script type=text/javascript src=js/fonts/bickham_script.typeface.js></script>
        <script type=text/javascript src=js/fonts/corinthia.typeface.js></script>
        <script type=text/javascript src=js/fonts/monotype_corsiva.typeface.js></script>
        <script type=text/javascript src=js/fonts/alexander.typeface.js></script>
        <script type=text/javascript src=js/fonts/carolina.typeface.js></script>
        <script type=text/javascript src=js/fonts/kaleidoscope.typeface.js></script>
        <script type=text/javascript src=js/fonts/l_script.typeface.js></script>
        <script type=text/javascript src=js/fonts/studio_script.typeface.js></script>
        <script id=ui-script></script>



