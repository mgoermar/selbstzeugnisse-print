<p:declare-step version="1.0" name="main"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input port="source" primary="true">
    <p:documentation>TEI source</p:documentation>
  </p:input>

  <p:variable name="basename" select="substring-before(tokenize(base-uri(/), '/')[last()], '.')"/>
  <p:variable name="outname"  select="concat($basename, '.pdf')"/>
  <p:variable name="xslname"  select="concat($basename, '.xsl')"/>

  <p:load name="load-stylesheet">
    <p:with-option name="href" select="resolve-uri(concat('../xslt/', $xslname), static-base-uri())"/>
  </p:load>

  <p:xslt name="tei-to-fo">
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe step="load-stylesheet" port="result"/>
    </p:input>
  </p:xslt>

  <p:xsl-formatter content-type="application/pdf" name="fo-to-pdf">
    <p:with-option name="href" select="resolve-uri(concat('../../', $outname), static-base-uri())"/>
    <p:with-param name="UserConfig" select="resolve-uri('../../conf/fop.xconf', static-base-uri())"/>
  </p:xsl-formatter>

</p:declare-step>
