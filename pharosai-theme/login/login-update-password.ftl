<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                
                <!-- Logo and Title -->
                <div class="text-center mb-8">
                    <div class="flex justify-center mb-4">
                        <div class="bg-gradient-to-r from-green-500 to-emerald-500 p-3 rounded-2xl">
                            <i data-lucide="shield-check" class="w-8 h-8 text-white"></i>
                        </div>
                    </div>
                    <h1 class="text-2xl font-bold text-white mb-2">${msg("updatePasswordTitle")}</h1>
                    <p class="text-gray-400">${msg("updatePasswordMsg")}</p>
                </div>

                <!-- Update Password Form -->
                <form id="kc-passwd-update-form" class="space-y-6" action="${url.loginAction}" method="post">
                    <div class="${properties.kcFormGroupClass!}">
                        <label for="password-new" class="block text-sm font-medium text-gray-300 mb-2">${msg("passwordNew")}</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i data-lucide="lock" class="w-5 h-5 text-gray-500"></i>
                            </div>
                            <input type="password" id="password-new" name="password-new" class="input-field w-full pl-10 pr-12 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('password',properties.kcFormGroupErrorClass!)}"
                                   autofocus autocomplete="new-password"
                                   aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                                   placeholder="${msg("passwordNew")}"/>
                            <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 pr-3 flex items-center" onclick="togglePassword('password-new')">
                                <i data-lucide="eye" class="w-5 h-5 text-gray-500 hover:text-gray-300 transition duration-200"></i>
                            </button>
                        </div>
                        <#if messagesPerField.existsError('password')>
                            <span id="input-error-password" class="text-red-400 text-sm mt-1" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('password'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="${properties.kcFormGroupClass!}">
                        <label for="password-confirm" class="block text-sm font-medium text-gray-300 mb-2">${msg("passwordConfirm")}</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i data-lucide="lock" class="w-5 h-5 text-gray-500"></i>
                            </div>
                            <input type="password" id="password-confirm" name="password-confirm" class="input-field w-full pl-10 pr-12 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('password-confirm',properties.kcFormGroupErrorClass!)}"
                                   autocomplete="new-password"
                                   aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                                   placeholder="${msg("passwordConfirm")}"/>
                            <button type="button" id="toggleConfirmPassword" class="absolute inset-y-0 right-0 pr-3 flex items-center" onclick="togglePassword('password-confirm')">
                                <i data-lucide="eye" class="w-5 h-5 text-gray-500 hover:text-gray-300 transition duration-200"></i>
                            </button>
                        </div>
                        <#if messagesPerField.existsError('password-confirm')>
                            <span id="input-error-password-confirm" class="text-red-400 text-sm mt-1" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="${properties.kcFormGroupClass!}">
                        <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                            <#if isAppInitiatedAction??>
                                <input class="btn-primary w-full font-bold py-3 px-4 rounded-lg text-lg shadow-lg hover:shadow-2xl transform hover:scale-105 transition duration-300 ease-in-out glow-effect mb-4" type="submit" value="${msg("doSubmit")}" />
                                <button class="glass-effect w-full inline-flex justify-center py-3 px-4 rounded-lg shadow-sm hover:bg-gray-700/30 transition duration-200 text-gray-300 font-bold" type="submit" name="cancel-aia" value="true" formnovalidate>
                                    ${msg("doCancel")}
                                </button>
                            <#else>
                                <input class="btn-primary w-full font-bold py-3 px-4 rounded-lg text-lg shadow-lg hover:shadow-2xl transform hover:scale-105 transition duration-300 ease-in-out glow-effect" type="submit" value="${msg("doSubmit")}" />
                            </#if>
                        </div>
                    </div>
                </form>
            </div>
        </div>
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