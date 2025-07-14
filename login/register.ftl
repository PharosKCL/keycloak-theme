<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm'); section>
    <#if section = "header">
        ${msg("registerTitle")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                
                <!-- Logo and Title -->
                <div class="text-center mb-8">
                    <div class="flex justify-center mb-4">
                        <div class="bg-gradient-to-r from-[#ee366d] to-[#de1379] p-3 rounded-2xl">
                            <i data-lucide="user-plus" class="w-8 h-8 text-white"></i>
                        </div>
                    </div>
                    <h1 class="text-2xl font-bold text-white mb-2">${msg("registerTitle")}</h1>
                    <p class="text-gray-400">${msg("loginTitleHtml",(realm.displayNameHtml!''))?no_esc}</p>
                </div>

                <!-- Registration Form -->
                <form id="kc-register-form" class="space-y-6" action="${url.registrationAction}" method="post">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="${properties.kcFormGroupClass!}">
                            <label for="firstName" class="block text-sm font-medium text-gray-300 mb-2">${msg("firstName")}</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-lucide="user" class="w-5 h-5 text-gray-500"></i>
                                </div>
                                <input type="text" id="firstName" class="input-field w-full pl-10 pr-4 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('firstName',properties.kcFormGroupErrorClass!)}" name="firstName"
                                       value="${(register.formData.firstName!'')}"
                                       aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"
                                       placeholder="${msg("firstName")}"/>
                            </div>
                            <#if messagesPerField.existsError('firstName')>
                                <span id="input-error-firstname" class="text-red-400 text-sm mt-1" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                                </span>
                            </#if>
                        </div>

                        <div class="${properties.kcFormGroupClass!}">
                            <label for="lastName" class="block text-sm font-medium text-gray-300 mb-2">${msg("lastName")}</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-lucide="user" class="w-5 h-5 text-gray-500"></i>
                                </div>
                                <input type="text" id="lastName" class="input-field w-full pl-10 pr-4 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('lastName',properties.kcFormGroupErrorClass!)}" name="lastName"
                                       value="${(register.formData.lastName!'')}"
                                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"
                                       placeholder="${msg("lastName")}"/>
                            </div>
                            <#if messagesPerField.existsError('lastName')>
                                <span id="input-error-lastname" class="text-red-400 text-sm mt-1" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </div>

                    <div class="${properties.kcFormGroupClass!}">
                        <label for="email" class="block text-sm font-medium text-gray-300 mb-2">${msg("email")}</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i data-lucide="mail" class="w-5 h-5 text-gray-500"></i>
                            </div>
                            <input type="text" id="email" class="input-field w-full pl-10 pr-4 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('email',properties.kcFormGroupErrorClass!)}" name="email"
                                   value="${(register.formData.email!'')}" autocomplete="email"
                                   aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
                                   placeholder="${msg("email")}"/>
                        </div>
                        <#if messagesPerField.existsError('email')>
                            <span id="input-error-email" class="text-red-400 text-sm mt-1" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('email'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <#if !realm.registrationEmailAsUsername>
                        <div class="${properties.kcFormGroupClass!}">
                            <label for="username" class="block text-sm font-medium text-gray-300 mb-2">${msg("username")}</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-lucide="at-sign" class="w-5 h-5 text-gray-500"></i>
                                </div>
                                <input type="text" id="username" class="input-field w-full pl-10 pr-4 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('username',properties.kcFormGroupErrorClass!)}" name="username"
                                       value="${(register.formData.username!'')}" autocomplete="username"
                                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                                       placeholder="${msg("username")}"/>
                            </div>
                            <#if messagesPerField.existsError('username')>
                                <span id="input-error-username" class="text-red-400 text-sm mt-1" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('username'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </#if>

                    <#if passwordRequired??>
                        <div class="${properties.kcFormGroupClass!}">
                            <label for="password" class="block text-sm font-medium text-gray-300 mb-2">${msg("password")}</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-lucide="lock" class="w-5 h-5 text-gray-500"></i>
                                </div>
                                <input type="password" id="password" class="input-field w-full pl-10 pr-12 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('password',properties.kcFormGroupErrorClass!)}" name="password"
                                       autocomplete="new-password"
                                       aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                                       placeholder="${msg("password")}"/>
                                <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 pr-3 flex items-center" onclick="togglePassword('password')">
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
                                <input type="password" id="password-confirm" class="input-field w-full pl-10 pr-12 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('password-confirm',properties.kcFormGroupErrorClass!)}" name="password-confirm"
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
                    </#if>

                    <#if recaptchaRequired??>
                        <div class="form-group">
                            <div class="${properties.kcInputWrapperClass!}">
                                <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                            </div>
                        </div>
                    </#if>

                    <div class="${properties.kcFormGroupClass!}">
                        <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                            <input class="btn-primary w-full font-bold py-3 px-4 rounded-lg text-lg shadow-lg hover:shadow-2xl transform hover:scale-105 transition duration-300 ease-in-out glow-effect" type="submit" value="${msg("doRegister")}"/>
                        </div>
                    </div>
                </form>

                <!-- Sign In Link -->
                <div class="mt-8 text-center">
                    <p class="text-gray-400">
                        <a href="${url.loginUrl}" class="text-[#ee366d] hover:text-[#de1379] font-medium transition duration-200">
                            ${msg("backToLogin")?no_esc}
                        </a>
                    </p>
                </div>
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