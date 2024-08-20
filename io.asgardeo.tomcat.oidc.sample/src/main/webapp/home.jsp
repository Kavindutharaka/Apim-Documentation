<%--
  ~ Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~ WSO2 Inc. licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file except
  ~ in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<%@ page import="io.asgardeo.java.oidc.sdk.SSOAgentConstants" %>
<%@ page import="io.asgardeo.java.oidc.sdk.bean.SessionContext" %>
<%@ page import="io.asgardeo.java.oidc.sdk.bean.User" %>
<%@ page import="io.asgardeo.java.oidc.sdk.config.model.OIDCAgentConfig" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="net.minidev.json.JSONObject" %>
<%@ page import="com.nimbusds.jwt.SignedJWT" %>

<%
    final HttpSession currentSession = request.getSession(false);
    final SessionContext sessionContext = (SessionContext)
            currentSession.getAttribute(SSOAgentConstants.SESSION_CONTEXT);
    final String idToken = sessionContext.getIdToken();

    String scopes = "";

    ServletContext servletContext = getServletContext();
    if (servletContext.getAttribute(SSOAgentConstants.CONFIG_BEAN_NAME) != null) {
        OIDCAgentConfig oidcAgentConfig = (OIDCAgentConfig) servletContext.getAttribute(SSOAgentConstants.CONFIG_BEAN_NAME);
        scopes = oidcAgentConfig.getScope().toString();
    }

    SignedJWT signedJWTIdToken = SignedJWT.parse(idToken);
    String payload = signedJWTIdToken.getJWTClaimsSet().toString();
    String header = signedJWTIdToken.getHeader().toString();

    String name = null;
    Map<String, Object> customClaimValueMap = new HashMap<>();

    if (idToken != null) {
        final User user = sessionContext.getUser();
        customClaimValueMap = user.getAttributes();
        name = user.getSubject();
    }
%>

<html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Migration Document</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Migration Document</h1>
        <div class="button-container">
            <form action="./MigrationDocs/API/site" method="post">
                <button type="submit" class="button">API</button>
            </form>
            <form action="./MigrationDocs/OB/site" method="post">
                <button type="submit" class="button">Open Banking</button>
            </form>
            <form action="./MigrationDocs/EI/site" method="post">
                <button type="submit" class="button">Enterprise Integration</button>
            </form>
        </div>
    </div>
</body>
</html>


