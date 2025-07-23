<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false showAnotherWayIfPresent=true>
<!DOCTYPE html>
<html lang="en" class="${properties.kcHtmlClass!}">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/logo.png" />
    
    <!-- External Dependencies -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    
    <!-- Theme CSS -->
    <link rel="stylesheet" href="https://theme.pharosai.co.uk/assets/styles/theme.css">
    
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}?v=${properties.cacheKey!'1.0'}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}?v=${properties.cacheKey!'1.0'}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="antialiased login-pf ${bodyClass}">
    <div class="animated-bg">
        <canvas id="brain-canvas" data-neuron-count="40" class="brain-canvas"></canvas>
    </div>

    <!-- Header -->
    <header class="navbar glass-effect" id="navbar">
        <div class="container">
            <div class="navbar-content">
                <div class="navbar-brand">
                    <img src="${url.resourcesPath}/img/logo.png" alt="Pharos AI Logo" class="brand-logo">
                    <div class="brand-text">
                        <span class="brand-highlight">P</span>haros<span class="brand-highlight">AI</span>
                    </div>
                </div>
                <#if realm.internationalizationEnabled && locale.supported?size gt 1>
                    <div id="kc-locale">
                        <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                            <div class="kc-dropdown" id="kc-locale-dropdown">
                                <a href="#" id="kc-current-locale-link" class="nav-back-btn">${locale.current}</a>
                                <ul class="${properties.kcLocaleListClass!}">
                                    <#list locale.supported as l>
                                        <li class="kc-dropdown-item"><a href="${l.url}" class="${properties.kcLocaleItemClass!}">${l.label}</a></li>
                                    </#list>
                                </ul>
                            </div>
                        </div>
                    </div>
                </#if>
            </div>
        </div>
    </header>

    <!-- Main Dialog Section -->
    <section class="dialog-section pt-navbar">
        <div class="container">
            <div class="dialog-wrapper max-w-lg">
                <div class="card glass-effect">
                    <div id="kc-container" class="${properties.kcContainerClass!}">
                        <div id="kc-container-wrapper" class="${properties.kcContainerWrapperClass!}">

                            <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
                                <#if displayRequiredFields>
                                    <div class="${properties.kcContentWrapperClass!}">
                                        <div class="${properties.kcLabelWrapperClass!} subtitle">
                                            <span class="subtitle"><span class="required">*</span> ${msg("requiredFields")}</span>
                                        </div>
                                        <div class="col-md-10">
                                            <#nested "header">
                                        </div>
                                    </div>
                                </#if>
                            <#else>
                                <#nested "show-username">
                                <div id="kc-username" class="form-group">
                                    <label id="kc-attempted-username">${auth.attemptedUsername}</label>
                                    <a id="reset-login" href="${url.loginRestartFlowUrl}">
                                        <div class="kc-login-tooltip">
                                            <i class="${properties.kcResetFlowIcon!}"></i>
                                            <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
                                        </div>
                                    </a>
                                </div>
                            </#if>

                            <div id="kc-content">
                                <div id="kc-content-wrapper">

                                    <#-- App-initiated actions should not see warning messages about the need to complete the action -->
                                    <#-- during login.                                                                               -->
                                    <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                                        <div class="alert alert-${message.type}">
                                            <div class="alert-content">
                                                <div class="alert-icon">
                                                    <#if message.type = 'success'><i data-lucide="check"></i></#if>
                                                    <#if message.type = 'warning'><i data-lucide="alert-triangle"></i></#if>
                                                    <#if message.type = 'error'><i data-lucide="alert-circle"></i></#if>
                                                    <#if message.type = 'info'><i data-lucide="info"></i></#if>
                                                </div>
                                                <div class="alert-body">
                                                    <span class="kc-feedback-text">${kcSanitize(message.summary)?no_esc}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </#if>

                                    <#nested "form">

                                    <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
                                        <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                                            <div class="form-group mt-4">
                                                <input type="hidden" name="tryAnotherWay" value="on"/>
                                                <a href="#" id="try-another-way"
                                                   onclick="document.forms['kc-select-try-another-way-form'].submit();return false;"
                                                   class="text-accent">${msg("doTryAnotherWay")}</a>
                                            </div>
                                        </form>
                                    </#if>

                                    <#if displayInfo>
                                        <div id="kc-info" class="${properties.kcSignUpClass!}">
                                            <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                                                <#nested "info">
                                            </div>
                                        </div>
                                    </#if>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Scripts -->
    <script src="https://theme.pharosai.co.uk/assets/js/theme.js"></script>
</body>
</html>
</#macro>