<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">
    <div id="kc-form">
      <div id="kc-form-wrapper">
        
        <!-- Logo and Title -->
        <div class="text-center mb-8">
            <div class="flex justify-center mb-4">
                <div class="bg-gradient-primary p-3 rounded-2xl">
                    <i data-lucide="shield-check" class="w-8 h-8 text-white"></i>
                </div>
            </div>
            <h1 class="heading-2 mb-2">${msg("loginAccountTitle")}</h1>
            <p class="text-body-sm">${msg("loginTitleHtml",(realm.displayNameHtml!''))?no_esc}</p>
        </div>

        <#if realm.password>
            <!-- Login Form -->
            <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" class="space-y-6">
                <div class="form-group">
                    <label for="username"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>

                    <div class="input-icon-group">
                        <div class="input-icon">
                            <i data-lucide="mail" class="w-5 h-5"></i>
                        </div>
                        <#if usernameEditDisabled??>
                            <input tabindex="1" id="username" name="username" value="${(login.username!'')}" type="text" disabled placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"/>
                        <#else>
                            <input tabindex="1" id="username" class="${messagesPerField.printIfExists('username','invalid')}" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="off"
                                   aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                                   placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"/>
                        </#if>
                    </div>

                    <#if messagesPerField.existsError('username')>
                        <div class="error-message">
                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </div>
                    </#if>
                </div>

                <div class="form-group">
                    <label for="password">${msg("password")}</label>

                    <div class="input-icon-group">
                        <div class="input-icon">
                            <i data-lucide="lock" class="w-5 h-5"></i>
                        </div>
                        <input tabindex="2" id="password" class="${messagesPerField.printIfExists('password','invalid')}" name="password" type="password" autocomplete="off"
                               aria-invalid="<#if messagesPerField.existsError('password')>true</#if>"
                               placeholder="${msg("password")}"/>
                        <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center" onclick="togglePassword('password')">
                            <i data-lucide="eye" class="w-5 h-5 text-gray-500 hover:text-gray-300 transition duration-200"></i>
                        </button>
                    </div>

                    <#if messagesPerField.existsError('password')>
                        <div class="error-message">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </div>
                    </#if>
                </div>

                <div class="flex items-center justify-between">
                    <#if realm.rememberMe && !usernameEditDisabled??>
                        <label for="rememberMe" class="flex items-center gap-3">
                            <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if>>
                            ${msg("rememberMe")}
                        </label>
                    </#if>
                    <#if realm.resetPasswordAllowed>
                        <a href="${url.loginResetCredentialsUrl}" class="text-sm text-accent">
                            ${msg("doForgotPassword")}
                        </a>
                    </#if>
                </div>

                <div id="kc-form-buttons">
                  <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                  <input tabindex="4" class="btn btn-primary glow-effect w-full" name="login" id="kc-login" type="submit" value="${msg("doLogIn")}"/>
                </div>
            </form>
        </#if>

        <!-- Social Login -->
        <#if realm.password && social.providers??>
            <div class="mt-8">
                <div class="relative">
                    <div class="absolute inset-0 flex items-center">
                        <div class="w-full border-t border-gray-600"></div>
                    </div>
                    <div class="relative flex justify-center text-sm">
                        <span class="px-4 bg-surface text-body-sm">${msg("identity-provider-login-label")}</span>
                    </div>
                </div>

                <div class="mt-6 grid grid-cols-2 gap-3" id="kc-social-providers">
                    <#list social.providers as p>
                        <a id="social-${p.alias}" class="btn btn-glass kc-social-item" type="button" href="${p.loginUrl}">
                            <#if p.iconClasses?has_content>
                                <i class="${properties.kcCommonLogoIdP!} ${p.iconClasses!}" aria-hidden="true"></i>
                                <span class="ml-2">${p.displayName!}</span>
                            <#else>
                                <span>${p.displayName!}</span>
                            </#if>
                        </a>
                    </#list>
                </div>
            </div>
        </#if>

        <!-- Registration Link -->
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="mt-8 text-center">
                <p class="text-body-sm">
                    <a href="${url.registrationUrl}" class="text-accent font-medium transition duration-200">
                        ${msg("doRegister")}
                    </a>
                </p>
            </div>
        </#if>
      </div>
    </div>
    <#elseif section = "info" >
        <#-- Registration link is already handled in the form section above -->
    </#if>

</@layout.registrationLayout>

<script>
function togglePassword(inputId) {
    const passwordInput = document.getElementById(inputId);
    const toggleButton = passwordInput.nextElementSibling;
    const eyeIcon = toggleButton.querySelector('i');

    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        eyeIcon.setAttribute('data-lucide', 'eye-off');
    } else {
        passwordInput.type = 'password';
        eyeIcon.setAttribute('data-lucide', 'eye');
    }
    lucide.createIcons();
}
</script>