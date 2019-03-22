<xsl:transform version="2.0"
               xpath-default-namespace="http://www.tei-c.org/ns/1.0"
               xmlns="http://www.tei-c.org/ns/1.0"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:fun="tag:dmaus@dmaus.name,2018-02:XSLT"
               xmlns:fo="http://www.w3.org/1999/XSL/Format"
               xmlns:oai="http://www.openarchives.org/OAI/2.0/static-repository"
               xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="layout.xsl"/>

  <fun:map>
    <fun:entry key="01" value="Januar"/>
    <fun:entry key="02" value="Februar"/>
    <fun:entry key="03" value="März"/>
    <fun:entry key="04" value="April"/>
    <fun:entry key="05" value="Mai"/>
    <fun:entry key="06" value="Juni"/>
    <fun:entry key="07" value="Juli"/>
    <fun:entry key="08" value="August"/>
    <fun:entry key="09" value="September"/>
    <fun:entry key="10" value="Oktober"/>
    <fun:entry key="11" value="November"/>
    <fun:entry key="12" value="Dezember"/>
  </fun:map>

  <xsl:template match="oai:ListRecords[@metadataPrefix = 'tei']">
    <fo:root>
      <fo:layout-master-set>

        <!-- Die erste Seite -->
        <fo:simple-page-master master-name="first" page-height="297mm" page-width="210mm">
          <fo:region-body margin="20mm"/>
        </fo:simple-page-master>

        <fo:simple-page-master master-name="rest" page-height="297mm" page-width="210mm">
          <fo:region-body   margin="33mm 35mm 66mm 35mm"/>
          <fo:region-before extent="33mm"/>
          <fo:region-after  extent="66mm"/>
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="document">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference master-reference="first" page-position="first"/>
            <fo:conditional-page-master-reference master-reference="rest"  page-position="rest"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

      </fo:layout-master-set>

            <fo:declarations>
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
          <rdf:RDF>
            <rdf:Description rdf:about="">
              <dc:title>Digitales Selbstzeugnis-Repertorium</dc:title>
              <dc:creator>Inga Hanna Ralle</dc:creator>
              <dc:date>2018</dc:date>
              <pdf:Producer>David Maus &lt;dmaus@dmaus.name&gt;</pdf:Producer>
            </rdf:Description>
          </rdf:RDF>
        </x:xmpmeta>
      </fo:declarations>

      <fo:bookmark-tree>
        <xsl:variable name="inhaltsverzeichnis">
          <xsl:call-template name="inhaltsverzeichnis-einträge"/>
        </xsl:variable>
        <fo:bookmark internal-destination="titlepage">
          <fo:bookmark-title>Digitales Selbstzeugnis-Repertorium</fo:bookmark-title>
          <fo:bookmark internal-destination="inhaltsverzeichnis">
            <fo:bookmark-title>Inhaltsverzeichnis</fo:bookmark-title>
          </fo:bookmark>
          <xsl:apply-templates select="$inhaltsverzeichnis" mode="lesezeichen"/>
        </fo:bookmark>
      </fo:bookmark-tree>

      <fo:page-sequence language="de" master-reference="document" font-family="Junicode, Symbola, serif" font-size="10pt" line-height="150%">
        <fo:static-content flow-name="xsl-footnote-separator">
          <fo:block text-align-last="justify">
            <fo:leader leader-length="50%" rule-thickness="0.5pt" leader-pattern="rule"/>
          </fo:block>
        </fo:static-content>

        <fo:static-content flow-name="xsl-region-before">
          <fo:block-container position="absolute" left="35mm" right="35mm" height="25mm" border-bottom="thin solid black">
            <fo:block margin-top="18mm" text-align="right">
              <fo:retrieve-marker retrieve-class-name="Gattung"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="xsl-region-after">
          <fo:block text-align="center">
            <fo:page-number/>
          </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">

          <fo:block page-break-after="always" id="titlepage">
            <fo:block xsl:use-attribute-sets="heading" font-size="16pt" >
              Selbstzeugnisse der Frühen Neuzeit in der Herzog August Bibliothek: Digitales Selbstzeugnis-Repertorium
            </fo:block>
            <fo:block xsl:use-attribute-sets="paragraph" font-size="14pt" line-height="150%">
              Hrsg. von Inga Hanna Ralle, Technische Konzeption und Begleitung durch David Maus, unter Mitarbeit von
              Jacqueline Krone. Gefördert durch das Niedersächsische Ministerium für Wissenschaft und
              Kultur. Wolfenbüttel : Herzog August Bibliothek, 2015–2017.
            </fo:block>
            <fo:block xsl:use-attribute-sets="paragraph" font-size="14pt" line-height="150%">
              URL: <fo:basic-link external-destination="http://diglib.hab.de/edoc/ed000254/start.htm">http://diglib.hab.de/edoc/ed000254/start.htm</fo:basic-link>
            </fo:block>
          </fo:block>

          <xsl:call-template name="inhaltsverzeichnis"/>
          <xsl:call-template name="repertorium"/>
          <xsl:call-template name="register"/>
        </fo:flow>
      </fo:page-sequence>

    </fo:root>
  </xsl:template>

  <xsl:template name="inhaltsverzeichnis-einträge">
    <list>
      <item corresp="repertorium">
        <label>Repertorium</label>
        <list>
          <xsl:for-each-group select=".//msDesc" group-by="msPart/msContents/msItem/@class">
            <xsl:sort lang="de" select="current-grouping-key()"/>
            <item corresp="{substring-after(current-grouping-key(), '#')}">
              <label><xsl:value-of select="fun:gattungslabel(current-grouping-key())"/></label>
            </item>
          </xsl:for-each-group>
        </list>
      </item>
      <item corresp="register">
        <label>Register</label>
        <list>
          <item corresp="verfasser">
            <label>Verfasser</label>
          </item>
          <item corresp="handschriften">
            <label>Handschriften</label>
          </item>
        </list>
      </item>
    </list>
  </xsl:template>

  <xsl:template name="inhaltsverzeichnis">
    <xsl:variable name="inhaltsverzeichnis">
      <xsl:call-template name="inhaltsverzeichnis-einträge"/>
    </xsl:variable>
    <fo:block id="inhaltsverzeichnis">
      <fo:block xsl:use-attribute-sets="heading">
        Inhaltsverzeichnis
      </fo:block>
      <fo:block text-align-last="justify">
        <xsl:apply-templates select="$inhaltsverzeichnis" mode="inhaltsverzeichnis"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="text()" mode="inhaltsverzeichnis lesezeichen"/>

  <xsl:template match="item" mode="inhaltsverzeichnis">
    <fo:block margin-left="{(count(ancestor::list) - 1)}em">
      <fo:basic-link internal-destination="{@corresp}">
        <xsl:value-of select="label"/>
        <fo:inline>
          <fo:leader leader-pattern="dots"/>
        </fo:inline>
        <fo:page-number-citation ref-id="{@corresp}"/>
      </fo:basic-link>
    </fo:block>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="item" mode="lesezeichen">
    <fo:bookmark internal-destination="{@corresp}">
      <fo:bookmark-title>
        <xsl:value-of select="label"/>
      </fo:bookmark-title>
      <xsl:apply-templates mode="#current"/>
    </fo:bookmark>
  </xsl:template>

  <xsl:template name="repertorium">
    <fo:block>
      <fo:block xsl:use-attribute-sets="heading" id="repertorium">
        Repertorium
      </fo:block>
      <xsl:for-each-group select=".//msDesc" group-by="msPart/msContents/msItem/@class">
        <xsl:sort select="current-grouping-key()"/>
        <fo:block xsl:use-attribute-sets="subheading" id="{substring-after(current-grouping-key(), '#')}">
          <xsl:value-of select="fun:gattungslabel(current-grouping-key())"/>
        </fo:block>
        <xsl:for-each select="current-group()">
          <xsl:sort select="msPart/history/origin/@when"/>
          <xsl:call-template name="repertorium.eintrag"/>
        </xsl:for-each>
      </xsl:for-each-group>
    </fo:block>
  </xsl:template>

  <xsl:template name="repertorium.eintrag">
    <fo:block>
      <fo:marker marker-class-name="Gattung">
        <xsl:text>Repertorium · </xsl:text>
        <xsl:value-of select="fun:gattungslabel(.//msItem/@class)"/>
      </fo:marker>
      <fo:table page-break-after="always" id="{generate-id()}">
        <fo:table-column column-number="1" column-width="30%"/>
        <fo:table-column column-number="2" column-width="70%"/>
        <fo:table-body>

          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Verfasser</xsl:with-param>
            <xsl:with-param name="content" select=".//author[normalize-space()]"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Schreiber/Redaktor</xsl:with-param>
            <xsl:with-param name="content" select=".//respStmt"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Sachtitel</xsl:with-param>
            <xsl:with-param name="content" select=".//title[@type = 'uniform']"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Titel in Vorlageform</xsl:with-param>
            <xsl:with-param name="content" select=".//rubric"/>
          </xsl:call-template>

          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Berichtszeitraum</xsl:with-param>
            <xsl:with-param name="content" select="fun:zeitraum(.//date[@type = 'coverage'])"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Entstehungszeit</xsl:with-param>
            <xsl:with-param name="content" select="fun:zeitraum(.//origDate)"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Entstehungsort</xsl:with-param>
            <xsl:with-param name="content" select=".//origPlace"/>
          </xsl:call-template>

          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Aufbewahrungsort</xsl:with-param>
            <xsl:with-param name="content" select="concat('Herzog August Bibliothek Wolfenbüttel, ', .//collection)"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Signatur</xsl:with-param>
            <xsl:with-param name="content">
              <xsl:value-of select="msIdentifier/idno"/>
              <xsl:if test=".//msItem/locus/@from">
                <xsl:text>, beginnt auf </xsl:text>
                <xsl:value-of select=".//msItem/locus/@from"/>
              </xsl:if>
            </xsl:with-param>
          </xsl:call-template>

          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Zusammenfassung</xsl:with-param>
            <xsl:with-param name="content" select=".//summary"/>
          </xsl:call-template>

          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Sprache</xsl:with-param>
            <xsl:with-param name="content" select="fun:sprache(.//textLang/@mainLang)"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Beschreibstoff</xsl:with-param>
            <xsl:with-param name="content" select=".//material"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Umfang</xsl:with-param>
            <xsl:with-param name="content" select=".//measure"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Seitenzählung</xsl:with-param>
            <xsl:with-param name="content" select=".//foliation/p"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Seitenaufbau</xsl:with-param>
            <xsl:with-param name="content" select=".//layout/p"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Einband</xsl:with-param>
            <xsl:with-param name="content" select=".//bindingDesc"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Illustrationen</xsl:with-param>
            <xsl:with-param name="content" select=".//decoNote"/>
          </xsl:call-template>
          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Beigaben</xsl:with-param>
            <xsl:with-param name="content" select="accMat"/>
          </xsl:call-template>

          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Besitzgeschichte</xsl:with-param>
            <xsl:with-param name="content" select=".//p[parent::provenance or parent::acquisition]"/>
          </xsl:call-template>

          <xsl:call-template name="table-row">
            <xsl:with-param name="label">Bibliographische Verweise</xsl:with-param>
            <xsl:with-param name="content" select=".//additional/listBibl"/>
          </xsl:call-template>

        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="register">
    <fo:block>
      <fo:block xsl:use-attribute-sets="heading" id="register">
        Register
      </fo:block>
      <fo:block id="verfasser">
        <fo:marker marker-class-name="Gattung">
          <xsl:text>Register · Verfasser</xsl:text>
        </fo:marker>
        <fo:block xsl:use-attribute-sets="subheading">
          Verfasser
        </fo:block>
        <fo:block>
          <xsl:for-each-group select=".//author" group-by="@n">
            <xsl:sort select="current-grouping-key()"/>
            <fo:block start-indent="1em">
              <fo:inline xsl:use-attribute-sets="label">
                <xsl:value-of select="current-grouping-key()"/>
              </fo:inline>
              <fo:inline>
                <fo:leader leader-pattern="space"/>
              </fo:inline>
              <xsl:for-each select="current-group()">
                <xsl:if test="position() gt 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <fo:basic-link internal-destination="{generate-id(ancestor::msDesc)}">
                  <fo:page-number-citation ref-id="{generate-id(ancestor::msDesc)}"/>
                </fo:basic-link>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each-group>
        </fo:block>
      </fo:block>
      <fo:block id="handschriften">
        <fo:marker marker-class-name="Gattung">
          <xsl:text>Register · Handschriften</xsl:text>
        </fo:marker>
        <fo:block xsl:use-attribute-sets="subheading">
          Handschriften
        </fo:block>
        <xsl:for-each-group select=".//msDesc" group-by="tokenize(normalize-space(msIdentifier/collection), ' ')[1]">
          <xsl:sort select="current-grouping-key()"/>
          <fo:block xsl:use-attribute-sets="subsubheading">
            <xsl:value-of select="current-grouping-key()"/>
          </fo:block>
          <xsl:for-each-group select="current-group()" group-by="msIdentifier/idno">
            <xsl:sort select="current-grouping-key()"/>
            <fo:block start-indent="1em">
              <fo:inline xsl:use-attribute-sets="label">
                <xsl:value-of select="current-grouping-key()"/>
              </fo:inline>
              <fo:inline>
                <fo:leader leader-pattern="space"/>
              </fo:inline>
              <xsl:for-each select="current-group()">
                <xsl:if test="position() gt 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <fo:basic-link internal-destination="{generate-id()}">
                  <fo:page-number-citation ref-id="{generate-id()}"/>
                </fo:basic-link>
              </xsl:for-each>
            </fo:block>
          </xsl:for-each-group>
        </xsl:for-each-group>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="msDesc"/>

  <xsl:template name="table-row">
    <xsl:param name="label"/>
    <xsl:param name="content"/>
    <fo:table-row>
      <fo:table-cell>
        <fo:block font-weight="bold">
          <xsl:value-of select="$label"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:choose>
            <xsl:when test="empty($content)">
              <xsl:text>-</xsl:text>
            </xsl:when>
            <xsl:when test="$content instance of xs:string">
              <xsl:value-of select="$content"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$content" mode="copy"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="text()"/>

  <xsl:function name="fun:zeitraum" as="xs:string?">
    <xsl:param name="element" as="element()?"/>
    <xsl:value-of>
      <xsl:choose>
        <xsl:when test="normalize-space($element) != ''">
          <xsl:value-of select="$element"/>
        </xsl:when>
        <xsl:when test="$element/@from != '' or $element/@to != ''">
          <xsl:if test="$element/@from != ''">
            <xsl:call-template name="datum">
              <xsl:with-param name="datum" select="$element/@from"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:text>–</xsl:text>
          <xsl:if test="$element/@to != ''">
            <xsl:call-template name="datum">
              <xsl:with-param name="datum" select="$element/@to"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$element/@when != ''">
          <xsl:call-template name="datum">
            <xsl:with-param name="datum" select="$element/@when"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$element/@after">
          <xsl:text>nach </xsl:text>
          <xsl:call-template name="datum">
            <xsl:with-param name="datum" select="$element/@after"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$element/@notBefore">
          <xsl:text>nach </xsl:text>
          <xsl:call-template name="datum">
            <xsl:with-param name="datum" select="$element/@notBefore"/>
          </xsl:call-template>
        </xsl:when>

        <xsl:when test="$element/@before">
          <xsl:text>vor </xsl:text>
          <xsl:call-template name="datum">
            <xsl:with-param name="datum" select="$element/@before"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$element/@notAfter">
          <xsl:text>vor </xsl:text>
          <xsl:call-template name="datum">
            <xsl:with-param name="datum" select="$element/@notAfter"/>
          </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>-</xsl:otherwise>

      </xsl:choose>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="fun:sprache" as="xs:string">
    <xsl:param name="lang" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$lang = 'deu' or $lang = 'de'">Deutsch</xsl:when>
      <xsl:when test="$lang = 'lat' or $lang = 'la'">Latein</xsl:when>
      <xsl:when test="$lang = 'ces' or $lang = 'cs'">Tschechisch</xsl:when>
      <xsl:when test="$lang = 'nld' or $lang = 'nl'">Niederländisch</xsl:when>
      <xsl:when test="$lang = 'fra' or $lang = 'fr'">Französisch</xsl:when>
      <xsl:when test="$lang = 'eng' or $lang = 'en'">Englisch</xsl:when>
      <xsl:otherwise>Unbekannt/Keine Angabe</xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:template name="datum">
    <xsl:param name="datum"/>
    <xsl:variable name="j" select="substring($datum, 1, 4)"/>
    <xsl:variable name="m" select="substring($datum, 6, 2)"/>
    <xsl:variable name="d" select="substring($datum, 9, 2)"/>

    <xsl:if test="string-length($datum) = 10">
      <xsl:value-of select="$d"/>
      <xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:if test="string-length($datum) > 4">
      <xsl:value-of select="document('')//fun:entry[@key = $m]/@value"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="$j"/>
  </xsl:template>

  <xsl:template match="p | bibl" mode="copy">
    <fo:block xsl:use-attribute-sets="paragraph">
      <xsl:apply-templates mode="copy"/>
    </fo:block>
  </xsl:template>

  <xsl:function name="fun:gattungslabel" as="xs:string">
    <xsl:param name="uri" as="xs:anyURI"/>
    <xsl:value-of select="if (document($uri)) then normalize-space(document($uri)) else translate(substring-after($uri, '#'), '_', ' ')"/>
  </xsl:function>

</xsl:transform>
