<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tei="http://www.tei-c.org/ns/1.0"
xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:preserve-space elements="tei:p tei:s tei:hi tei:stamp"/>
	<xsl:strip-space elements="*"/>
	<!-- Struttura del file -->
	<xsl:template match="/tei:TEI">
		<html>
			<head>
				<title>Vincenzo Bellini a Giuditta Turina, in Venezia, 20 gennaio 1830</title>
				<link href="LL1.2.css" rel="stylesheet" type="text/css"/>
				<script src="LL1.2.js"></script>
			</head>
			<body>
				<div id="header" class="container">
					<h1>Informazioni sul documento</h1>
					<xsl:apply-templates select="tei:teiHeader//tei:titleStmt"/>
					<xsl:apply-templates select="tei:teiHeader//tei:editionStmt"/>
					<xsl:apply-templates select="tei:teiHeader//tei:publicationStmt"/>
					<xsl:apply-templates select="tei:teiHeader//tei:msDesc"/>
					<xsl:apply-templates select="tei:teiHeader/tei:profileDesc"/>
				</div>
				<div id="fronte" class="container">
					<h1>Frontespizio</h1>
					<h2>
						<xsl:attribute name="id"><xsl:value-of select="translate(tei:text/tei:front//tei:div[@type='sent']/tei:ab/@facs, '#', '')"/></xsl:attribute>
						Mittente
					</h2>
					<xsl:apply-templates select="tei:text/tei:front//tei:div[@type='sent']"/>
					<h2>Destinatario</h2>
					<xsl:apply-templates select="tei:text/tei:front//tei:div[@type='destination']"/>
				</div>
				<div id="blocco-visual">
					<div id="flexbox">
						<img id="arrowb" src="arrow.png" onclick="scorri(this)"/>
						<div id="scansioni">
							<xsl:apply-templates select="tei:facsimile"/>
						</div>
						<div id="testo">
							<h1>Testo</h1>
							<xsl:apply-templates select="tei:text/tei:body"/>
						</div>
						<div id="frasi">
							<h1>Evidenzia frasi</h1>
							<xsl:call-template name="create_buttons"/>
						</div>
						<img id="arrowf" src="arrow.png" onclick="scorri(this)"/>
					</div>
				</div>
				<div id="appendici" class="container">
					<h1>Appendici</h1>
					<xsl:apply-templates select="tei:text/tei:back//tei:div[@type='notes']"/>
					<xsl:apply-templates select="tei:teiHeader//tei:listPerson"/>
					<xsl:apply-templates select="tei:teiHeader//tei:listPlace"/>
					<xsl:apply-templates select="tei:teiHeader//tei:listOrg"/>
					<xsl:apply-templates select="tei:teiHeader//tei:list[@type='terminology']"/>
					<xsl:apply-templates select="tei:text/tei:back/tei:div[@type='biblCompleta']"/>
					<xsl:apply-templates select="tei:text/tei:back/tei:div[@type='work']"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<!-- Sezioni principali -->
	<xsl:template match="tei:titleStmt">
		<h2><xsl:value-of select="tei:title"/></h2>
		<p>
			<b>Author</b>: <a onclick="linkaNota(this)">
                <xsl:attribute name="href"><xsl:value-of select="tei:author/@ref"/></xsl:attribute>
                <xsl:value-of select="tei:author"/>
            </a>
		</p>
		<xsl:apply-templates select="tei:respStmt"/>
	</xsl:template>
	<xsl:template match="tei:editionStmt">
		<h2><xsl:value-of select="tei:edition"/></h2>
		<xsl:apply-templates select="tei:respStmt"/>
	</xsl:template>
	<xsl:template match="tei:publicationStmt">
		<h2>Pubblicazione</h2>
		<p>
			<xsl:value-of select="tei:publisher"/>, 
			<xsl:value-of select="tei:pubPlace"/>, 
			<a>
				<xsl:attribute name="href"><xsl:value-of select="tei:availability/tei:licence/@target"/></xsl:attribute>
				<xsl:value-of select="tei:availability/tei:licence"/>
			</a>, 
			<xsl:value-of select="tei:date"/>
		</p>
	</xsl:template>
	<xsl:template match="tei:msDesc">
		<div id="desc">
			<h2>
				Descrizione documento
				<a class="super" onclick="linkaNota(this)">
					<xsl:attribute name="href"><xsl:value-of select="../tei:bibl/@source"/></xsl:attribute>
					<xsl:attribute name="title">pp. <xsl:value-of select="../tei:bibl/tei:citedRange"/></xsl:attribute>fonte
				</a>
			</h2>
			<h3 onclick="mostraNota(this)" style="cursor: pointer">Identificatore<xsl:text>&#32;&#9662;</xsl:text></h3>
			<div style="display: none">
				<p><b>Città</b>: <xsl:value-of select="tei:msIdentifier/tei:settlement"/>, <xsl:value-of select="tei:msIdentifier/tei:country"/></p>
				<p>
					<b>Museo</b>: 
					<a>
						<xsl:attribute name="href"><xsl:value-of select="tei:msIdentifier/tei:repository/@ref"/></xsl:attribute>
						<xsl:value-of select="tei:msIdentifier/tei:repository"/>
					</a>
				</p>
				<p><b>Codice</b>: <xsl:value-of select="tei:msIdentifier/tei:idno"/></p>
				<p><b>Collocazione</b>: <xsl:value-of select="tei:msIdentifier/tei:altIdentifier/tei:idno"/></p>
			</div>
			<h3 onclick="mostraNota(this)" style="cursor: pointer">Contenuti<xsl:text>&#32;&#9662;</xsl:text></h3>
			<div style="display: none">
				<p>
					<b>Autore</b>: 
					<a onclick="linkaNota(this)">
						<xsl:attribute name="href"><xsl:value-of select="tei:msContents//tei:author/@ref"/></xsl:attribute>
						<xsl:value-of select="tei:msContents//tei:author"/>
					</a>
				</p>
				<p><b>Titolo</b>: <xsl:apply-templates select="tei:msContents//tei:title"/></p>
				<p><b>Lingua</b>: <xsl:value-of select="tei:msContents//tei:textLang"/></p>
				<p><b>Nota</b>: <xsl:apply-templates select="tei:msContents//tei:note"/></p>
			</div>
			<h3>Descrizione fisica</h3>
			<h4 onclick="mostraNota(this)" style="cursor: pointer">Descrizione oggetto<xsl:text>&#32;&#9662;</xsl:text></h4>
			<div style="display: none">
				<p><b>Materiale</b>: <xsl:value-of select="tei:physDesc//tei:material"/></p>
				<p><b><xsl:value-of select="tei:physDesc//tei:head"/></b>:</p>
				<img width="15%"><xsl:attribute name="src"><xsl:value-of select="tei:physDesc//tei:graphic/@url"/></xsl:attribute></img>
				<p><b>Timbro</b>: <xsl:value-of select="tei:physDesc//tei:stamp"/></p>
				<p><b>Caratteristiche</b>: <xsl:value-of select="tei:physDesc//tei:support/tei:p"/></p>
				<p><b>Numero di fogli</b>: <xsl:value-of select="tei:physDesc//tei:measure"/></p>
				<p><b>Altezza</b>: <xsl:value-of select="tei:physDesc//tei:height"/> <xsl:value-of select="tei:physDesc//tei:dimensions/@unit"/></p>
				<p><b>Larghezza</b>: <xsl:value-of select="tei:physDesc//tei:width"/> <xsl:value-of select="tei:physDesc//tei:dimensions/@unit"/></p>
				<p><b>Struttura</b>: <xsl:value-of select="tei:physDesc//tei:foliation"/></p>
				<p><b>Condizioni</b>: <xsl:value-of select="tei:physDesc//tei:condition/tei:p"/></p>
			</div>
			<h4>Descrizione mani:</h4>
			<ol>
				<xsl:for-each select="tei:physDesc//tei:handNote">
					<li>
						<xsl:if test="@xml:id">
							<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
						</xsl:if>
						<xsl:value-of select="tei:p"/>
					</li>
				</xsl:for-each>
			</ol>
			<h4>
				<xsl:attribute name="id"><xsl:value-of select="translate(tei:physDesc//tei:seal/@facs, '#', '')"/></xsl:attribute>
				Descrizione sigillo:
			</h4>
			<div>
				<p><xsl:value-of select="tei:physDesc//tei:seal/tei:p"/></p>
			</div>
			<h3>Catalogazione:</h3>
			<div>
				<p><xsl:value-of select="tei:additional//tei:note"/></p>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="tei:profileDesc">
		<h2 onclick="mostraNota(this)" style="cursor: pointer">Contestualizzazione<xsl:text>&#32;&#9662;</xsl:text></h2>
		<div style="display: none">
			<xsl:for-each select="tei:correspDesc/tei:correspAction">
				<h3>
					<xsl:choose>
						<xsl:when test="@type='sent'">Mittente:</xsl:when>
						<xsl:otherwise>Destinatario:</xsl:otherwise>
					</xsl:choose>
				</h3>
				<p>
					<xsl:apply-templates select="tei:persName"/>, 
					<xsl:apply-templates select="tei:placeName"/>, 
					<xsl:choose>
						<xsl:when test="tei:date/text()='unknown'">data sconosciuta</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="tei:date"/>
							<a class="super">
								<xsl:attribute name="href"><xsl:value-of select="tei:date/@resp"/></xsl:attribute>fonte
							</a>
						</xsl:otherwise>
					</xsl:choose></p>
			</xsl:for-each>
			<h3>Contesto:</h3>
			<p><xsl:apply-templates select="tei:correspDesc//tei:p"/></p>
			<h3>Tipologia del testo:</h3>
			<p>
				<xsl:value-of select="tei:textClass//tei:term"/>
				(<a>
					<xsl:attribute name="href"><xsl:value-of select="tei:textClass/tei:keywords/@scheme"/></xsl:attribute>
					<xsl:value-of select="tei:textClass/tei:keywords/@scheme"/>
				</a>)
				<a class="super">
					<xsl:attribute name="href"><xsl:value-of select="tei:textClass//tei:term/@resp"/></xsl:attribute>fonte
				</a>
			</p>
			<h3>Lingue:</h3>
			<p>
				<xsl:for-each select="tei:langUsage/tei:language">
					<xsl:value-of select="."/>;
				</xsl:for-each>
			</p>
		</div>
	</xsl:template>
	<xsl:template match="tei:surface">
		<div class="img">
			<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
			<img><xsl:attribute name="src"><xsl:value-of select="tei:graphic/@url"/></xsl:attribute></img>
			<!-- Vengono generati dei tag a che permettono di visualizzare delle evidenziazioni responsive sulle scansioni al passaggio del mouse, ed eventualmente funzionare da link -->
			<xsl:for-each select="tei:zone">
				<a onmouseover="evidenzia(this)" onmouseout="disevidenzia(this)">
					<xsl:attribute name="class"><xsl:value-of select="@xml:id"/></xsl:attribute>
					<xsl:variable name="ulx" select="@ulx"/>
					<xsl:variable name="uly" select="@uly"/>
					<xsl:variable name="lrx" select="@lrx"/>
					<xsl:variable name="lry" select="@lry"/>
					<xsl:variable name="width" select="translate(../tei:graphic/@width, 'px', '')"/>
					<xsl:variable name="height" select="translate(../tei:graphic/@height, 'px', '')"/>
					<xsl:attribute name="style">
						position: absolute; left: <xsl:value-of select="$ulx div $width * 100"/>%; top: <xsl:value-of select="$uly div $height * 100"/>%; width: <xsl:value-of select="($lrx - $ulx) div $width * 100"/>%; height: <xsl:value-of select="($lry - $uly) div $height * 100"/>%;
						<xsl:choose>
							<xsl:when test="@rendition='HotSpot'">
								z-index: 0;
							</xsl:when>
							<xsl:otherwise>
								z-index: 1;
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="@xml:id='LL1.2_hotspot_1fv_01' or @xml:id='LL1.2_hotspot_1fv_05'">
						<xsl:attribute name="href">#<xsl:value-of select="@xml:id"/></xsl:attribute>
					</xsl:if>
				</a>
			</xsl:for-each>
		</div>
	</xsl:template>
	<xsl:template match="tei:div[@type='paratext']">
		<h2>Paratesto</h2>
		<ul>
			<xsl:for-each select="tei:ab">
				<li>
					<a>
						<xsl:attribute name="class"><xsl:value-of select="translate(@facs, '#', '')"/></xsl:attribute>
						<xsl:attribute name="href"><xsl:value-of select="@hand"/></xsl:attribute>
						<xsl:apply-templates select="."/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template match="tei:div[@type='ann_notes']">
		<div>
			<xsl:attribute name="id"><xsl:value-of select="@type"/></xsl:attribute>
			<h2>Note della lettera LL1.2</h2>
			<ol>
				<xsl:for-each select="tei:note">
					<li>
						<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
						<xsl:apply-templates select="./tei:p"/>
					</li>
				</xsl:for-each>
			</ol>
		</div>
	</xsl:template>
	<xsl:template match="tei:div[@type='bibliography']">
		<div>
			<xsl:attribute name="id"><xsl:value-of select="tei:listBibl/@xml:id"/></xsl:attribute>
			<h2><xsl:value-of select="tei:listBibl/tei:head"/></h2>
			<ol>
				<xsl:for-each select="tei:listBibl/tei:bibl">
					<li>
						<a onclick="linkaNota(this)">
							<xsl:attribute name="href"><xsl:value-of select="tei:ref/@target"/></xsl:attribute>
							<xsl:attribute name="title">pp. <xsl:value-of select="tei:ref/tei:bibl/tei:citedRange"/></xsl:attribute>
							<xsl:value-of select="tei:ref/tei:bibl/tei:author"/>, <xsl:value-of select="tei:ref/tei:bibl/tei:date"/>
						</a>
					</li>
				</xsl:for-each>
			</ol>
		</div>
	</xsl:template>
	<xsl:template match="tei:listPerson">
		<div id="pers">
			<h2><xsl:value-of select="tei:head"/></h2>
			<ul>
				<xsl:for-each select="tei:person">
					<li class="persElement">
						<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
						<h3 onclick="mostraNota(this)" style="cursor: pointer">
							<xsl:for-each select="tei:persName/tei:surname">
								<xsl:value-of select="."/>
								<xsl:text>&#32;</xsl:text>
							</xsl:for-each>
							<xsl:for-each select="tei:persName/tei:forename">
								<i><xsl:value-of select="."/></i>
								<xsl:text>&#32;</xsl:text>
							</xsl:for-each>
							<xsl:text>&#9662;</xsl:text>
						</h3>
						<div style="display: none">
							<xsl:if test="tei:persName/tei:addName">
								<p><b>Soprannome</b>: <xsl:value-of select="tei:persName/tei:addName"/></p>
							</xsl:if>
							<xsl:if test="tei:persName/tei:roleName">
								<p><b>Titolo</b>: <xsl:value-of select="tei:persName/tei:roleName"/></p>
							</xsl:if>
							<p><b>Sesso</b>: <xsl:value-of select="tei:sex"/></p>
							<p><b>Data di nascita</b>: <xsl:value-of select="tei:birth/tei:date"/></p>
							<xsl:if test="not(tei:birth/tei:placeName[@type='unknown'])">
								<p><b>Luogo di nascita</b>: 
									<xsl:choose>
										<xsl:when test="tei:birth/tei:placeName/@ref">
											<a onclick="linkaNota(this)">
												<xsl:attribute name="href"><xsl:value-of select="tei:birth/tei:placeName/@ref"/></xsl:attribute>
												<xsl:for-each select="tei:birth/tei:placeName/tei:settlement">
													<xsl:value-of select="."/><xsl:text>,&#32;</xsl:text>
												</xsl:for-each>
												<xsl:value-of select="tei:birth/tei:placeName/tei:country"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="tei:birth/tei:placeName/tei:settlement">
												<xsl:value-of select="."/><xsl:text>,&#32;</xsl:text>
											</xsl:for-each>
											<xsl:value-of select="tei:birth/tei:placeName/tei:country"/>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</xsl:if>
							<p><b>Data di morte</b>: <xsl:value-of select="tei:death/tei:date"/></p>
							<xsl:if test="not(tei:death/tei:placeName[@type='unknown'])">
								<p><b>Luogo di morte</b>: 
									<xsl:choose>
										<xsl:when test="tei:death/tei:placeName/@ref">
											<a onclick="linkaNota(this)">
												<xsl:attribute name="href"><xsl:value-of select="tei:death/tei:placeName/@ref"/></xsl:attribute>
												<xsl:for-each select="tei:death/tei:placeName/tei:settlement">
													<xsl:value-of select="."/><xsl:text>,&#32;</xsl:text>
												</xsl:for-each>
												<xsl:value-of select="tei:death/tei:placeName/tei:country"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="tei:death/tei:placeName/tei:settlement">
												<xsl:value-of select="."/><xsl:text>,&#32;</xsl:text>
											</xsl:for-each>
											<xsl:value-of select="tei:death/tei:placeName/tei:country"/>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</xsl:if>
							<xsl:call-template name="relation">
								<xsl:with-param name="id" select="@xml:id"/>
							</xsl:call-template>
							<xsl:if test="@sameAs">
								<p class="refer">
									<b>Riferimenti</b>: 
									<a>
										<xsl:attribute name="href"><xsl:value-of select="@sameAs"/></xsl:attribute>
										<xsl:value-of select="@sameAs"/>
									</a>; 
									<!-- Viene controllato se l'attributo target contiene più di un link (separati da uno spazio) e vengono generati i tag a di conseguenza -->
									<xsl:choose>
										<xsl:when test="substring-before(tei:persName/tei:ref/@target, ' ')">
											<a>
												<xsl:attribute name="href"><xsl:value-of select="substring-before(tei:persName/tei:ref/@target, ' ')"/></xsl:attribute>
												<xsl:value-of select="substring-before(tei:persName/tei:ref/@target, ' ')"/>
											</a>; 
											<a>
												<xsl:attribute name="href"><xsl:value-of select="substring-after(tei:persName/tei:ref/@target, ' ')"/></xsl:attribute>
												<xsl:value-of select="substring-after(tei:persName/tei:ref/@target, ' ')"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<a>
												<xsl:attribute name="href"><xsl:value-of select="tei:persName/tei:ref/@target"/></xsl:attribute>
												<xsl:value-of select="tei:persName/tei:ref/@target"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</xsl:if>
							<xsl:apply-templates select="tei:note/tei:p"/>
						</div>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="tei:listPlace">
		<div id="place">
			<h2><xsl:value-of select="tei:head"/></h2>
			<ul>
				<xsl:for-each select="tei:place">
					<li class="placeElement">
						<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
						<h3 onclick="mostraNota(this)" style="cursor: pointer"><xsl:value-of select="tei:placeName"/><xsl:text>&#32;&#9662;</xsl:text></h3>
						<div style="display: none">
							<xsl:if test="tei:district">
								<p><b>Distretto</b>: <xsl:value-of select="tei:district"/></p>
							</xsl:if>
							<xsl:if test="tei:settlement">
								<p><b>Città</b>: <xsl:value-of select="tei:settlement"/></p>
							</xsl:if>
							<p><b>Nazione</b>: <xsl:value-of select="tei:country"/></p>
							<xsl:call-template name="relation">
								<xsl:with-param name="id" select="@xml:id"/>
							</xsl:call-template>
							<p class="refer">
								<b>Riferimenti</b>: 
								<!-- Vengono generati i due tag a per i due link contenuti nell'attributo target separati da uno spazio -->
								<a>
									<xsl:attribute name="href"><xsl:value-of select="substring-before(tei:placeName/@ref, ' ')"/></xsl:attribute>
									<xsl:value-of select="substring-before(tei:placeName/@ref, ' ')"/>
								</a>; 
								<a>
									<xsl:attribute name="href"><xsl:value-of select="substring-after(tei:placeName/@ref, ' ')"/></xsl:attribute>
									<xsl:value-of select="substring-after(tei:placeName/@ref, ' ')"/>
								</a>
							</p>
							<xsl:apply-templates select="tei:note/tei:p"/>
						</div>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="tei:listOrg">
		<div id="org">
			<h2><xsl:value-of select="tei:head"/></h2>
			<ul>
				<xsl:for-each select="tei:org">
					<li class="orgElement">
						<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
						<h3 onclick="mostraNota(this)" style="cursor: pointer"><xsl:value-of select="tei:orgName"/><xsl:text>&#32;&#9662;</xsl:text></h3>
						<div style="display: none">
							<p><b>Città</b>: <xsl:apply-templates select="tei:placeName"/></p>
							<p class="refer">
								<b>Riferimenti</b>: 
								<a>
									<xsl:attribute name="href"><xsl:value-of select="tei:orgName/@ref"/></xsl:attribute>
									<xsl:value-of select="tei:orgName/@ref"/>
								</a>
							</p>
						</div>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="tei:list[@type='terminology']">
		<div id="term">
			<h2><xsl:value-of select="tei:head"/></h2>
			<ul>
				<xsl:for-each select="tei:label">
					<li class="termElement">
						<xsl:attribute name="id"><xsl:value-of select="tei:term/@xml:id"/></xsl:attribute>
						<h3 onclick="mostraNota(this)" style="cursor: pointer"><xsl:value-of select="tei:term"/><xsl:text>&#32;&#9662;</xsl:text></h3>
						<div style="display: none">
							<p>
								<xsl:apply-templates select="following-sibling::tei:item[1]/tei:gloss"/>
								<a class="super" onclick="linkaNota(this)">
									<xsl:attribute name="href"><xsl:value-of select="following-sibling::tei:item[1]/tei:gloss/@source"/></xsl:attribute>fonte
								</a>
							</p>
						</div>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="tei:div[@type='biblCompleta']">
		<div id="bibl">
			<h2>Bibliografia completa</h2>
			<ul>
				<xsl:for-each select="tei:listBibl/tei:bibl">
					<li class="biblElement">
						<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
						<h3 onclick="mostraNota(this)" style="cursor: pointer"><xsl:value-of select="tei:title"/><xsl:text>&#32;&#9662;</xsl:text></h3>
						<div style="display: none">
							<xsl:if test="tei:editor">
								<p>
									<b>Curatore</b>: 
									<xsl:choose>
										<xsl:when test="tei:editor/@xml:id">
											<span>
												<xsl:attribute name="id"><xsl:value-of select="tei:editor/@xml:id"/></xsl:attribute>
												<xsl:value-of select="tei:editor/tei:forename"/><xsl:text>&#32;</xsl:text><xsl:value-of select="tei:editor/tei:surname"/>
											</span>
										</xsl:when>
										<xsl:otherwise>
											<a>
												<xsl:attribute name="href"><xsl:value-of select="tei:editor/@ref"/></xsl:attribute>
												<xsl:value-of select="tei:editor/tei:forename"/><xsl:text>&#32;</xsl:text><xsl:value-of select="tei:editor/tei:surname"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</xsl:if>
							<xsl:if test="tei:author">
								<p>
									<b>Autore</b>: 
									<span>
										<xsl:attribute name="id"><xsl:value-of select="tei:author/@xml:id"/></xsl:attribute>
										<xsl:value-of select="tei:author/tei:forename"/><xsl:text>&#32;</xsl:text><xsl:value-of select="tei:author/tei:surname"/>
									</span>
								</p>
							</xsl:if>
							<xsl:if test="tei:biblScope">
								<p><b>Bibliografia</b>: <xsl:value-of select="tei:title[2]"/>, <xsl:value-of select="tei:biblScope[1]"/>, <xsl:value-of select="tei:biblScope[2]"/></p>
							</xsl:if>
							<p><b>Città di pubblicazione</b>: <xsl:value-of select="tei:pubPlace"/></p>
							<xsl:if test="tei:publisher">
								<p><b>Editore</b>: <xsl:value-of select="tei:publisher"/></p>
							</xsl:if>
							<p><b>Data</b>: <xsl:value-of select="tei:date"/></p>
						</div>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="tei:div[@type='work']">
		<div id="work">
			<h2>Lista delle opere</h2>
			<ul>
				<xsl:for-each select="tei:listBibl/tei:bibl">
					<li class="workElement">
						<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
						<h3 onclick="mostraNota(this)" style="cursor: pointer"><xsl:value-of select="tei:title"/><xsl:text>&#32;&#9662;</xsl:text></h3>
						<div style="display: none">
							<p>
								<b>Compositore</b>: 
								<xsl:choose>
									<xsl:when test="tei:note[1]/tei:ref">
										<a onclick="linkaNota(this)">
											<xsl:attribute name="href"><xsl:value-of select="tei:note[1]/tei:ref/@target"/></xsl:attribute>
											<xsl:value-of select="tei:note[1]"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="tei:note[1]"/>
									</xsl:otherwise>
								</xsl:choose>
							</p>
							<p>
								<b>Librettista</b>: 
								<xsl:choose>
									<xsl:when test="tei:note[2]/tei:ref">
										<a onclick="linkaNota(this)">
											<xsl:attribute name="href"><xsl:value-of select="tei:note[2]/tei:ref/@target"/></xsl:attribute>
											<xsl:value-of select="tei:note[2]"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="tei:note[2]"/>
									</xsl:otherwise>
								</xsl:choose>
							</p>
							<p><b>Teatro</b>: <xsl:apply-templates select="tei:orgName[@type='theatre']"/></p>
							<p><b>Città</b>: <xsl:apply-templates select="tei:placeName"/></p>
							<p><b>Data</b>: <xsl:value-of select="tei:date"/></p>
							<p class="refer">
								<b>Riferimenti</b>: 
								<a>
									<xsl:attribute name="href"><xsl:value-of select="tei:ref/@target"/></xsl:attribute>
									<xsl:value-of select="tei:ref/@target"/>
								</a>
							</p>
							<xsl:apply-templates select="tei:note/tei:p"/>
						</div>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	<!-- Tag ricorrenti -->
	<xsl:template match="tei:body/tei:div">
		<div>
			<xsl:attribute name="id"><xsl:value-of select="@type"/></xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="tei:respStmt">
		<xsl:choose>
			<xsl:when test="tei:name[2]">
				<h3><xsl:value-of select="tei:resp"/>:</h3>
				<ul>
					<xsl:for-each select="tei:name">
						<li>
							<xsl:choose>
								<xsl:when test="@xml:id">
									<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
									<xsl:value-of select="."/><xsl:text>;&#32;</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<a>
										<xsl:attribute name="href"><xsl:value-of select="@ref"/></xsl:attribute>
										<xsl:value-of select="."/>
									</a><xsl:text>;&#32;</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<b><xsl:value-of select="tei:resp"/></b>: 
					<span>
						<xsl:attribute name="id"><xsl:value-of select="tei:name/@xml:id"/></xsl:attribute>
						<xsl:value-of select="tei:name"/>
					</span>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:lb">
		<xsl:if test="@rend='double stroke'">
			<span class="sub">=</span>
		</xsl:if>
		<xsl:variable name="accapo"><![CDATA[<br/>]]></xsl:variable>
		<xsl:value-of select="$accapo" disable-output-escaping="yes"/>
		<span onmouseover="evidenzia(this)" onmouseout="disevidenzia(this)">
			<xsl:attribute name="class">line <xsl:value-of select="translate(@facs, '#', '')"/></xsl:attribute>
			<xsl:if test="../../@rend='first_line_indented' and count(preceding-sibling::tei:lb)=0 and count(../preceding-sibling::tei:s)=0">
				<xsl:attribute name="style">margin-right: 15%;</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="not(@n > 9)">
					0<xsl:value-of select="@n"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@n"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="tei:ptr">
		<span class="super">[<a>
				<xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
				<!-- Viene preso l'ultimo carattere della stringa dell'attributo target, che corrisponde al numero della nota -->
				<xsl:value-of select="substring(@target, string-length(@target))"/>
			</a>]</span>
	</xsl:template>
	<xsl:template match="tei:distinct">
		<span class="dist">
			<xsl:if test="@type='archaic'">
				<xsl:attribute name="title">forma arcaica</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:unclear">
		<i title="non chiaro"><xsl:apply-templates/></i>
	</xsl:template>
	<xsl:template match="tei:hi">
		<xsl:choose>
			<xsl:when test="@rend='italic'">
				<i><xsl:apply-templates/></i>
			</xsl:when>
			<xsl:when test="@rend='underline'">
				<u><xsl:apply-templates/></u>
			</xsl:when>
			<xsl:when test="@rend='align(right)'">
				<span class="right"><xsl:apply-templates/></span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:g[@rend='superscript']">
		<span class="super"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="tei:quote[@rend='double angle quotation marks']">
		<xsl:text>&#171;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#187;</xsl:text>
	</xsl:template>
	<xsl:template match="tei:s">
		<div class="frase">
			<xsl:attribute name="id"><xsl:value-of select="@n"/></xsl:attribute>
			<xsl:call-template name="sentence_join">
				<xsl:with-param name="id" select="@n"/>
			</xsl:call-template>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="tei:choice">
		<span class="dist">
			<xsl:choose>
				<xsl:when test="tei:sic">
					<xsl:attribute name="title"><xsl:value-of select="tei:corr"/></xsl:attribute>
					<xsl:value-of select="tei:sic"/>
				</xsl:when>
				<xsl:when test="tei:abbr">
					<xsl:attribute name="title"><xsl:value-of select="tei:expan"/></xsl:attribute>
					<xsl:value-of select="tei:abbr"/>
				</xsl:when>
			</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="tei:note/tei:p">
		<p>
			<xsl:apply-templates/>
			<xsl:choose>
				<xsl:when test="../@source">
					<a class="super" onclick="linkaNota(this)">
						<xsl:attribute name="href"><xsl:value-of select="../@source"/></xsl:attribute>
						<xsl:if test="..//tei:citedRange">
							<xsl:attribute name="title">pp. <xsl:value-of select="..//tei:citedRange"/></xsl:attribute>
						</xsl:if>fonte
					</a>
				</xsl:when>
				<xsl:when test="../@resp">
					<a class="super">
						<xsl:attribute name="href"><xsl:value-of select="../@resp"/></xsl:attribute>fonte
					</a>
				</xsl:when>
			</xsl:choose>
		</p>
	</xsl:template>
	<xsl:template match="tei:persName|tei:placeName|tei:orgName|tei:term|tei:rs[@type='work']">
		<xsl:choose>
			<xsl:when test="@ref">
				<a onclick="linkaNota(this)">
					<xsl:attribute name="href"><xsl:value-of select="@ref"/></xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:when test="name(..)='p' or name(..)='gloss'">
				<b><xsl:apply-templates/></b>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template funzione -->
	<!-- Il call-template genera i bottoni e gli assegna la funzione coi paramentri corretti per evidenziare le frasi -->
	<xsl:template name="create_buttons">
		<div id="frasi-fronte" class="column">
			<xsl:for-each select="//tei:div[@type='fronte-recto']//tei:s">
				<button type="button">
					<xsl:attribute name="onclick">
						<xsl:choose>
							<xsl:when test="contains(@n, 'a') or contains(@n, 'b')">
								evidenziaFrase('doppio', '<xsl:value-of select="@n"/>')
							</xsl:when>
							<xsl:otherwise>
								evidenziaFrase(this, '<xsl:value-of select="@n"/>')
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:choose>
							<xsl:when test="contains(@n, 's_0')">
								<xsl:value-of select="substring-after(@n, '_0')"/>
							</xsl:when>
							<xsl:when test="contains(@n, 's_')">
								<xsl:value-of select="substring-after(@n, '_')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="contains(@n, 'a')">
							<xsl:value-of select="substring-before(substring-after(@n, '_0'), 'a')"/>
						</xsl:when>
						<xsl:when test="contains(@n, 'b')">
							<xsl:value-of select="substring-before(substring-after(@n, '_0'), 'b')"/>
						</xsl:when>
						<xsl:when test="contains(@n, 's_0')">
							<xsl:value-of select="substring-after(@n, '_0')"/>
						</xsl:when>
						<xsl:when test="contains(@n, 's_')">
							<xsl:value-of select="substring-after(@n, '_')"/>
						</xsl:when>
					</xsl:choose>
					<xsl:text>&#7491;</xsl:text>
				</button>
			</xsl:for-each>
		</div>
		<div id="frasi-retro" class="column">
			<xsl:for-each select="//tei:div[@type='retro-recto']//tei:s">
				<button type="button">
					<xsl:attribute name="onclick">
						<xsl:choose>
							<xsl:when test="contains(@n, 'a') or contains(@n, 'b')">
								evidenziaFrase('doppio', '<xsl:value-of select="@n"/>')
							</xsl:when>
							<xsl:otherwise>
								evidenziaFrase(this, '<xsl:value-of select="@n"/>')
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:choose>
							<xsl:when test="contains(@n, 's_0')">
								<xsl:value-of select="substring-after(@n, '_0')"/>
							</xsl:when>
							<xsl:when test="contains(@n, 's_')">
								<xsl:value-of select="substring-after(@n, '_')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="contains(@n, 'a')">
							<xsl:value-of select="substring-before(substring-after(@n, '_0'), 'a')"/>
						</xsl:when>
						<xsl:when test="contains(@n, 'b')">
							<xsl:value-of select="substring-before(substring-after(@n, '_0'), 'b')"/>
						</xsl:when>
						<xsl:when test="contains(@n, 's_0')">
							<xsl:value-of select="substring-after(@n, '_0')"/>
						</xsl:when>
						<xsl:when test="contains(@n, 's_')">
							<xsl:value-of select="substring-after(@n, '_')"/>
						</xsl:when>
					</xsl:choose>
					<xsl:text>&#7491;</xsl:text>
				</button>
			</xsl:for-each>
		</div>
	</xsl:template>
	<!-- Il call-template assegna ai segmenti di frase l'attributo title contenente la parte mancante della frase -->
	<xsl:template name="sentence_join">
		<xsl:param name="id"/>
		<xsl:for-each select="../../../..//tei:join">
			<!-- Vengono salvati gli id dei due segmenti di frase separati da uno spazio -->
			<xsl:variable name="b" select="substring-before(@target, ' ')"/>
			<xsl:variable name="a" select="substring-after(@target, ' ')"/>
			<xsl:if test="$b=concat('#', $id)">
				<xsl:attribute name="title">
					<xsl:value-of select="../../..//tei:s[@n=translate($a, '#', '')]"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$a=concat('#', $id)">
				<xsl:attribute name="title">
					<xsl:apply-templates select="../../..//tei:s[@n=translate($b, '#', '')]"/>
				</xsl:attribute>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- Il call-template genera dei link di collegamento alle named entity che sono in relazione tra loro -->
	<xsl:template name="relation">
		<xsl:param name="id"/>
		<xsl:for-each select="..//tei:relation">
			<!-- Vengono salvati gli id delle due named entity separati da uno spazio -->
			<xsl:variable name="b" select="substring-before(@mutual, ' ')"/>
			<xsl:variable name="a" select="substring-after(@mutual, ' ')"/>
			<xsl:if test="$b=concat('#', $id)">
				<a onclick="linkaNota(this)">
					<xsl:attribute name="href">
						<xsl:value-of select="$a"/>
					</xsl:attribute>
					<xsl:if test="@name='spouse'">
						Coniuge di
					</xsl:if>
					<xsl:if test="@name='near'">
						Vicino a
					</xsl:if>
				</a>
			</xsl:if>
			<xsl:if test="$a=concat('#', $id)">
				<a onclick="linkaNota(this)">
					<xsl:attribute name="href">
						<xsl:value-of select="$b"/>
					</xsl:attribute>
					<xsl:if test="@name='spouse'">
						Coniuge di
					</xsl:if>
					<xsl:if test="@name='near'">
						Vicino a
					</xsl:if>
				</a>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>