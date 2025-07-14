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
                <div class="bg-gradient-to-r from-[#ee366d] to-[#de1379] p-3 rounded-2xl">
                    <i data-lucide="shield-check" class="w-8 h-8 text-white"></i>
                </div>
            </div>
            <h1 class="text-2xl font-bold text-white mb-2">${msg("loginAccountTitle")}</h1>
            <p class="text-gray-400">${msg("loginTitleHtml",(realm.displayNameHtml!''))?no_esc}</p>
        </div>

        <#if realm.password>
            <!-- Login Form -->
            <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" class="space-y-6">
                <div class="${properties.kcFormGroupClass!}">
                    <label for="username" class="block text-sm font-medium text-gray-300 mb-2"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>

                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i data-lucide="mail" class="w-5 h-5 text-gray-500"></i>
                        </div>
                        <#if usernameEditDisabled??>
                            <input tabindex="1" id="username" class="input-field w-full pl-10 pr-4 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none" name="username" value="${(login.username!'')}" type="text" disabled placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"/>
                        <#else>
                            <input tabindex="1" id="username" class="input-field w-full pl-10 pr-4 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('username',properties.kcFormGroupErrorClass!)}" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="off"
                                   aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                                   placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"/>
                        </#if>
                    </div>

                    <#if messagesPerField.existsError('username')>
                        <span id="input-error-username" class="text-red-400 text-sm mt-1" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </span>
                    </#if>
                </div>

                <div class="${properties.kcFormGroupClass!}">
                    <label for="password" class="block text-sm font-medium text-gray-300 mb-2">${msg("password")}</label>

                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i data-lucide="lock" class="w-5 h-5 text-gray-500"></i>
                        </div>
                        <input tabindex="2" id="password" class="input-field w-full pl-10 pr-12 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('password',properties.kcFormGroupErrorClass!)}" name="password" type="password" autocomplete="off"
                               aria-invalid="<#if messagesPerField.existsError('password')>true</#if>"
                               placeholder="${msg("password")}"/>
                        <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center" onclick="togglePassword('password')">
                            <i data-lucide="eye" class="w-5 h-5 text-gray-500 hover:text-gray-300 transition duration-200"></i>
                        </button>
                    </div>

                    <#if messagesPerField.existsError('password')>
                        <span id="input-error-password" class="text-red-400 text-sm mt-1" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </span>
                    </#if>
                </div>

                <div class="flex items-center justify-between">
                    <#if realm.rememberMe && !usernameEditDisabled??>
                        <div class="flex items-center">
                            <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" 
                                class="h-4 w-4 text-[#ee366d] focus:ring-[#ee366d] border-gray-600 rounded bg-gray-700"
                                <#if login.rememberMe??>checked</#if>>
                            <label for="rememberMe" class="ml-2 block text-sm text-gray-300">${msg("rememberMe")}</label>
                        </div>
                    </#if>
                    <#if realm.resetPasswordAllowed>
                        <a href="${url.loginResetCredentialsUrl}" class="text-sm text-[#ee366d] hover:text-[#de1379] transition duration-200">
                            ${msg("doForgotPassword")}
                        </a>
                    </#if>
                </div>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                  <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                  <input tabindex="4" class="btn-primary w-full font-bold py-3 px-4 rounded-lg text-lg shadow-lg hover:shadow-2xl transform hover:scale-105 transition duration-300 ease-in-out glow-effect" name="login" id="kc-login" type="submit" value="${msg("doLogIn")}"/>
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
                        <span class="px-4 bg-[#0e0e23] text-gray-400">${msg("identity-provider-login-label")}</span>
                    </div>
                </div>

                <div class="mt-6 grid grid-cols-2 gap-3" id="kc-social-providers">
                    <#list social.providers as p>
                        <a id="social-${p.alias}" class="glass-effect w-full inline-flex justify-center py-3 px-4 rounded-lg shadow-sm hover:bg-gray-700/30 transition duration-200 kc-social-item" type="button" href="${p.loginUrl}">
                            <#if p.iconClasses?has_content>
                                <i class="${properties.kcCommonLogoIdP!} ${p.iconClasses!}" aria-hidden="true"></i>
                                <span class="ml-2 text-gray-300">${p.displayName!}</span>
                            <#else>
                                <span class="text-gray-300">${p.displayName!}</span>
                            </#if>
                        </a>
                    </#list>
                </div>
            </div>
        </#if>

        <!-- Registration Link -->
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="mt-8 text-center">
                <p class="text-gray-400">
                    <a href="${url.registrationUrl}" class="text-[#ee366d] hover:text-[#de1379] font-medium transition duration-200">
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

// Initialize brain animation and icons when document loads
document.addEventListener('DOMContentLoaded', function() {
    // Initialize brain animation if canvas exists
    const brainCanvas = document.getElementById('brain-canvas');
    if (brainCanvas && typeof initBrainAnimation === 'function') {
        initBrainAnimation('brain-canvas');
    }
    
    // Initialize Lucide icons
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
});
</script>