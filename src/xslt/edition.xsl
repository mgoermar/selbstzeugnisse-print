<xsl:transform version="2.0"
               xmlns="http://www.tei-c.org/ns/1.0"
               xpath-default-namespace="http://www.tei-c.org/ns/1.0"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:fun="tag:dmaus@dmaus.name,2018-02:XSLT"
               xmlns:fo="http://www.w3.org/1999/XSL/Format"
               xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="layout.xsl"/>

  <xsl:key name="personen" match="rs[ancestor::group][@type = 'person'][@ref]" use="substring(@ref, 2)"/>
  <xsl:key name="orte" match="rs[ancestor::group][@type = 'place'][@ref]" use="substring(@ref, 2)"/>

  <xsl:template match="TEI">
    <fo:root>
      <fo:layout-master-set>

        <!-- Die erste Seite -->
        <fo:simple-page-master master-name="first" page-height="297mm" page-width="210mm">
          <fo:region-body margin="20mm"/>
        </fo:simple-page-master>

        <fo:simple-page-master master-name="rest" page-height="297mm" page-width="210mm">
          <!-- Satzspiegel klassisch, einseitig -->
          <fo:region-body   margin="33mm 35mm 66mm 35mm"/>
          <!-- Satzspiegel klassisch, zweiseitig -->
          <!-- <fo:region-body   margin="33mm 47.7mm 66mm 35mm"/> -->
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
              <dc:title>Digitale Edition des Diariums von Herzog August dem Jüngeren</dc:title>
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
          <fo:bookmark-title>Digitale Edition des Diariums von Herzog August dem Jüngeren</fo:bookmark-title>
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
              <fo:retrieve-marker retrieve-class-name="Kolumnentitel"/>
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
            <fo:block xsl:use-attribute-sets="heading" font-size="16pt">
              Selbstzeugnisse der Frühen Neuzeit in der Herzog August Bibliothek: Digitale Edition des Diariums von Herzog August dem Jüngeren
            </fo:block>
            <fo:block xsl:use-attribute-sets="paragraph" font-size="14pt" line-height="150%">
              Hrsg. von Inga Hanna Ralle, Technische Konzeption und Begleitung durch David Maus, unter Mitarbeit von
              Jacqueline Krone. Gefördert durch das Niedersächsische Ministerium für Wissenschaft und
              Kultur. Wolfenbüttel : Herzog August Bibliothek, 2015–2017.
            </fo:block>
            <fo:block xsl:use-attribute-sets="paragraph" font-size="14pt" line-height="150%">
              DOI: <fo:basic-link external-destination="http://dx.doi.org/10.15499/edoc/ed000225">10.15499/edoc/ed000225</fo:basic-link>
            </fo:block>
          </fo:block>

          <xsl:call-template name="inhaltsverzeichnis"/>
          <xsl:call-template name="edition"/>
          <xsl:call-template name="register"/>

        </fo:flow>
      </fo:page-sequence>

    </fo:root>
  </xsl:template>

  <xsl:template name="inhaltsverzeichnis-einträge">
    <list>
      <xsl:for-each select="text/front//div/head[count(ancestor::div/head) eq 1]">
        <item corresp="{generate-id()}">
          <label><xsl:value-of select="normalize-space()"/></label>
        </item>
      </xsl:for-each>
      <item corresp="diarium">
        <label>Ephemerides. Sive Diarium (1594-1635)</label>
        <list>
          <xsl:for-each select="text/group/text/body">
            <item corresp="{generate-id()}">
              <label>
                <xsl:value-of>
                  <xsl:value-of select="format-date((.//div/head/date[1]/@when)[1], '[Y]')"/>
                  <xsl:text> (</xsl:text>
                  <xsl:value-of select="format-date((.//div/head/date[1]/@when)[1], '[D01].[M01].')"/>
                  <xsl:text>–</xsl:text>
                  <xsl:value-of select="format-date((.//div/head/date/@when)[last()], '[D01].[M01].[Y]')"/>
                  <xsl:text>)</xsl:text>
                </xsl:value-of>
              </label>
            </item>
          </xsl:for-each>
        </list>
      </item>
      <item corresp="register">
        <label>Register</label>
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

  <xsl:template name="edition">
    <xsl:apply-templates select="text/front"/>
    <xsl:apply-templates select="text/group" mode="diarium"/>
  </xsl:template>

  <xsl:template match="p | bibl">
    <fo:block xsl:use-attribute-sets="paragraph">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="div">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="div/head[count(ancestor::div/head) eq 1]">
    <fo:block xsl:use-attribute-sets="heading" page-break-before="always" id="{generate-id()}">
      <fo:marker marker-class-name="Kolumnentitel">
        <xsl:value-of select="."/>
      </fo:marker>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="div/head[count(ancestor::div/head) gt 1]">
    <fo:block xsl:use-attribute-sets="subheading">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="list | listBibl">
    <fo:block xsl:use-attribute-sets="paragraph">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="list/head | listBibl/head">
    <fo:inline xsl:use-attribute-sets="label">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="list/item[not(preceding-sibling::item)] | listBibl/bibl[not(preceding-sibling::bibl)]">
    <fo:inline>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="list/item[preceding-sibling::item] | listBibl/bibl[preceding-sibling::bibl]">
    <fo:block xsl:use-attribute-sets="paragraph">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="rs | lb | ref">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="ref[@target][not(starts-with(@target, 'http://selbstzeugnisse.hab.de'))]">
    <fo:basic-link external-destination="{@target}">
      <xsl:apply-templates/>
    </fo:basic-link>
  </xsl:template>

  <!-- Diarium -->
  <xsl:template match="body" mode="diarium">
    <fo:block id="{generate-id()}">
      <xsl:apply-templates mode="#current"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="div" mode="diarium">
    <fo:block xsl:use-attribute-sets="paragraph" id="{generate-id()}">
      <xsl:apply-templates mode="#current"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="group/head" mode="diarium">
    <fo:block xsl:use-attribute-sets="heading" id="diarium">
      <fo:marker marker-class-name="Kolumnentitel">
        <xsl:value-of select="."/>
      </fo:marker>
        <xsl:apply-templates mode="#current"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="div/head[not(date)]" mode="diarium">
    <fo:block xsl:use-attribute-sets="heading">
      <xsl:apply-templates mode="#current"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="head[date] | label[date]" mode="diarium">
    <fo:inline xsl:use-attribute-sets="label">
      <fo:marker marker-class-name="Kolumnentitel">
        <xsl:value-of select="format-date(date/@when, '[D01].[M01].[Y]')"/>
      </fo:marker>
      <xsl:apply-templates mode="#current"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="p[not(preceding-sibling::p)]" mode="diarium">
    <fo:inline>
      <xsl:apply-templates mode="#current"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="p[preceding-sibling::p]" mode="diarium">
    <fo:block xsl:use-attribute-sets="paragraph">
      <xsl:apply-templates mode="#current"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="ex" mode="diarium">
    <fo:inline font-style="italic">
      <xsl:apply-templates mode="#current"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="hi[@rend = 'superscript']" mode="diarium">
    <fo:inline baseline-shift="super">
      <xsl:apply-templates mode="#current"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="hi[@rend = 'underline']" mode="diarium">
    <fo:inline text-decoration="underline">
      <xsl:apply-templates mode="#current"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="note[not(normalize-space())]" mode="diarium"/>

  <xsl:template match="note[starts-with(@type, 'annota') or empty(@*)][ancestor::div][normalize-space()]" mode="diarium">
    <fo:footnote xsl:use-attribute-sets="footnote">
      <fo:inline baseline-shift="super" font-size="6pt">
        <xsl:number level="any" count="note[starts-with(@type, 'annota') or empty(@*)][ancestor::div][normalize-space()]"/>
      </fo:inline>
      <fo:footnote-body>
        <fo:block start-indent="0em">
          <fo:inline space-end="0.5em">
            <xsl:number level="any" count="note[starts-with(@type, 'annota') or empty(@*)][ancestor::div][normalize-space()]"/>
            <xsl:text>)</xsl:text>
          </fo:inline>
          <xsl:apply-templates mode="#current"/>
        </fo:block>
      </fo:footnote-body>
    </fo:footnote>
  </xsl:template>

  <xsl:template match="ref[@target]" mode="diarium">
    <xsl:value-of select="@target"/>
  </xsl:template>

  <xsl:template match="del" mode="diarium">
    <fo:inline text-decoration="line-through">
      <xsl:apply-templates mode="#current"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="add" mode="diarium">
    <fo:inline baseline-shift="super">+</fo:inline>
    <xsl:apply-templates mode="#current"/>
    <fo:inline baseline-shift="super">+</fo:inline>
  </xsl:template>

  <xsl:template match="note[@type = 'translation'][normalize-space()]" mode="diarium">
    <fo:inline font-size="9pt" font-weight="400">
      <xsl:text> &#x2329;</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>&#x232A;</xsl:text>
    </fo:inline>
  </xsl:template>

  <xsl:template match="head[@rend]" mode="diarium" priority="10">
    <fo:block>
      <xsl:apply-templates mode="#current"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="note[@place or starts-with(@type, 'margin-')][normalize-space()]" mode="diarium">
    <fo:inline font-size="9pt" space-start="0.5em" space-end="0.5em" font-weight="400">
      <xsl:text>|&#x261E; </xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>|</xsl:text>
    </fo:inline>
  </xsl:template>

  <xsl:template match="lg" mode="diarium">
    <fo:block start-indent="2em" xsl:use-attribute-sets="paragraph">
      <xsl:apply-templates mode="#current"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="unclear" mode="diarium">
    <xsl:apply-templates mode="#current"/>
    <xsl:text>[?]</xsl:text>
  </xsl:template>

  <xsl:template match="l" mode="diarium">
    <fo:block>
      <xsl:apply-templates mode="#current"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[ancestor::div or ancestor::p]" priority="-50" mode="#all">
    <fo:inline color="red" id="{generate-id()}">
      <xsl:value-of select="concat('FIXME! &lt;', name())"/>
      <xsl:for-each select="@*">
        <xsl:value-of select="concat(name(), '=', .)"/>
        <xsl:if test="position() ne 1">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:value-of select="concat('&lt;/', name(), '&gt;')"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="item" mode="diarium">
    <fo:inline>
      <xsl:apply-templates mode="#current"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="pb[@n]" mode="diarium">
    <xsl:element name="fo:{if (ancestor::div) then 'inline' else 'block'}" namespace="http://www.w3.org/1999/XSL/Format">
      <xsl:attribute name="font-size">9pt</xsl:attribute>
      <fo:basic-link external-destination="{@facs}">
        <xsl:value-of select="concat('[[', @n, ']]')"/>
      </fo:basic-link>
    </xsl:element>
  </xsl:template>

  <xsl:template match="seg[@rend = 'august']" mode="diarium">
    <xsl:text>{:</xsl:text>
    <xsl:apply-templates mode="#current"/>
    <xsl:text>:}</xsl:text>
  </xsl:template>

  <xsl:template match="c | date | foreign | list | rs | seg | subst | w" mode="diarium">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template name="register">
    <fo:block xsl:use-attribute-sets="heading" id="register">Register</fo:block>
    <fo:block>
      <fo:marker marker-class-name="Kolumnentitel">
        Personen
      </fo:marker>
      <fo:block xsl:use-attribute-sets="subheading">Personen</fo:block>
      <xsl:for-each select="text/back/listPerson/person[key('personen', @xml:id)][normalize-space(persName)]">
        <xsl:sort select="normalize-space(persName)" lang="de"/>
        <fo:block>
          <fo:inline xsl:use-attribute-sets="label">
            <xsl:value-of select="persName"/>
          </fo:inline>
          <fo:inline>
            <fo:leader leader-pattern="space"/>
          </fo:inline>
          <xsl:for-each-group select="key('personen', @xml:id)[ancestor::div[1]/head/date/@when]" group-by="ancestor::div[1]/@xml:id">
            <xsl:if test="position() gt 1">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <fo:basic-link internal-destination="{generate-id(ancestor::div[1])}">
              <xsl:value-of select="format-date(ancestor::div[1]/head/date/@when[1], '[D01].[M01].[Y]')"/>
            </fo:basic-link>
          </xsl:for-each-group>
        </fo:block>
      </xsl:for-each>
    </fo:block>
    <fo:block page-break-before="always">
      <fo:marker marker-class-name="Kolumnentitel">
        Orte
      </fo:marker>
      <fo:block xsl:use-attribute-sets="subheading">Orte</fo:block>
      <xsl:for-each select="text/back/listPlace/place[key('orte', @xml:id)][normalize-space(placeName)]">
        <xsl:sort select="normalize-space(placeName)" lang="de"/>
        <fo:block>
          <fo:inline xsl:use-attribute-sets="label">
            <xsl:value-of select="placeName"/>
          </fo:inline>
          <fo:inline>
            <fo:leader leader-pattern="space"/>
          </fo:inline>
          <xsl:for-each-group select="key('orte', @xml:id)[ancestor::div[1]/head/date/@when]" group-by="ancestor::div[1]/@xml:id">
            <xsl:if test="position() gt 1">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <fo:basic-link internal-destination="{generate-id(ancestor::div[1])}">
              <xsl:value-of select="format-date(ancestor::div[1]/head/date/@when[1], '[D01].[M01].[Y]')"/>
            </fo:basic-link>
          </xsl:for-each-group>
        </fo:block>
      </xsl:for-each>
    </fo:block>
  </xsl:template>

</xsl:transform>
