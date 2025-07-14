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

    <style>
    /* Brain/Neuron Canvas Styles */
    #neuron-canvas, .brain-canvas {
        width: 100%;
        height: 100%;
    }

    /* Background and brain animation containers */
    .animated-bg {
        position: relative;
        background-color: #0a0a1a;
        overflow: hidden;
    }

    .animated-bg canvas {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: 0;
    }

    .content-overlay {
        position: relative;
        z-index: 1;
    }

    /* Hide default keycloak styles that conflict */
    body.login-pf {
        background: #0a0a1a !important;
    }
    
    .login-pf-page {
        background: #0a0a1a !important;
    }

    #kc-header {
        display: none;
    }

    #kc-container {
        position: relative;
        z-index: 1;
    }

    #kc-container-wrapper {
        background: transparent;
        border: none;
        box-shadow: none;
        padding: 0;
    }
    </style>
</head>

<body class="antialiased login-pf ${bodyClass}">

    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 z-50 transition-all duration-300 glass-effect" id="navbar">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-4">
                    <img src="${url.resourcesPath}/img/logo.png" alt="Pharos AI Logo" class="h-12 w-12 rounded-lg shadow-lg bg-white bg-opacity-10 p-1.5">
                    <div class="text-2xl font-bold text-white tracking-wider">
                        <span style="color: #f18322;">P</span>haros<span style="color: #f18322;">AI</span>
                    </div>
                </div>
                <#if realm.internationalizationEnabled && locale.supported?size gt 1>
                    <div id="kc-locale">
                        <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                            <div class="kc-dropdown" id="kc-locale-dropdown">
                                <a href="#" id="kc-current-locale-link" class="text-gray-400 hover:text-white transition duration-200">${locale.current}</a>
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
    <section class="animated-bg min-h-screen flex items-center justify-center py-20">
        <div class="absolute inset-0 opacity-30">
            <canvas id="brain-canvas" data-neuron-count="40" class="brain-canvas w-full h-full"></canvas>
        </div>
        <div class="container mx-auto px-6 content-overlay">
            <div class="max-w-lg mx-auto">
                <div class="login-card glass-effect rounded-2xl p-8 shadow-2xl">
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
                                <div id="kc-username" class="${properties.kcFormGroupClass!}">
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
                                        <div class="alert alert-${message.type} mb-4 p-4 rounded-lg border ${message.type == 'error'?then('border-red-500 bg-red-900/20 text-red-200', message.type == 'warning'?then('border-yellow-500 bg-yellow-900/20 text-yellow-200', 'border-green-500 bg-green-900/20 text-green-200'))}">
                                            <#if message.type = 'success'><span class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                                            <#if message.type = 'warning'><span class="${properties.kcFeedbackWarningIcon!}"></span></#if>
                                            <#if message.type = 'error'><span class="${properties.kcFeedbackErrorIcon!}"></span></#if>
                                            <#if message.type = 'info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                                            <span class="kc-feedback-text">${kcSanitize(message.summary)?no_esc}</span>
                                        </div>
                                    </#if>

                                    <#nested "form">

                                    <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
                                        <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                                            <div class="${properties.kcFormGroupClass!} mt-4">
                                                <input type="hidden" name="tryAnotherWay" value="on"/>
                                                <a href="#" id="try-another-way"
                                                   onclick="document.forms['kc-select-try-another-way-form'].submit();return false;"
                                                   class="text-[#ee366d] hover:text-[#de1379] transition duration-200">${msg("doTryAnotherWay")}</a>
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
    <script src="${url.resourcesPath}/js/theme.js"></script>
    <script src="${url.resourcesPath}/js/brain.js"></script>
    <script>
        // Initialize brain animation
        try {
            initBrainAnimation('brain-canvas');
        } catch (e) {
            console.log('Brain animation not available:', e);
        }
        
        // Initialize Lucide icons
        try {
            lucide.createIcons();
        } catch (e) {
            console.log('Lucide icons not available:', e);
        }
    </script>

</body>
</html>
</#macro>