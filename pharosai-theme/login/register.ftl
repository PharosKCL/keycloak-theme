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
                        <div class="bg-gradient-primary p-3 rounded-2xl">
                            <i data-lucide="user-plus" class="w-8 h-8 text-white"></i>
                        </div>
                    </div>
                    <h1 class="heading-2 mb-2">${msg("registerTitle")}</h1>
                    <p class="text-body-sm">${msg("loginTitleHtml",(realm.displayNameHtml!''))?no_esc}</p>
                </div>

                <!-- Registration Form -->
                <form id="kc-register-form" class="space-y-6" action="${url.registrationAction}" method="post">
                    <div class="form-grid cols-2">
                        <div class="form-group">
                            <label for="firstName">${msg("firstName")}</label>
                            <div class="input-icon-group">
                                <div class="input-icon">
                                    <i data-lucide="user" class="w-5 h-5"></i>
                                </div>
                                <input type="text" id="firstName" class="${messagesPerField.printIfExists('firstName',properties.kcFormGroupErrorClass!)}" name="firstName"
                                       value="${(register.formData.firstName!'')}"
                                       aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"
                                       placeholder="${msg("firstName")}" required/>
                            </div>
                            <#if messagesPerField.existsError('firstName')>
                                <span id="input-error-firstname" class="error-message" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                                </span>
                            </#if>
                        </div>

                        <div class="form-group">
                            <label for="lastName">${msg("lastName")}</label>
                            <div class="input-icon-group">
                                <div class="input-icon">
                                    <i data-lucide="user" class="w-5 h-5"></i>
                                </div>
                                <input type="text" id="lastName" class="${messagesPerField.printIfExists('lastName',properties.kcFormGroupErrorClass!)}" name="lastName"
                                       value="${(register.formData.lastName!'')}"
                                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"
                                       placeholder="${msg("lastName")}" required/>
                            </div>
                            <#if messagesPerField.existsError('lastName')>
                                <span id="input-error-lastname" class="error-message" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email">${msg("email")}</label>
                        <div class="input-icon-group">
                            <div class="input-icon">
                                <i data-lucide="mail" class="w-5 h-5"></i>
                            </div>
                            <input type="text" id="email" class="${messagesPerField.printIfExists('email',properties.kcFormGroupErrorClass!)}" name="email"
                                   value="${(register.formData.email!'')}" autocomplete="email"
                                   aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
                                   placeholder="${msg("email")}" required/>
                        </div>
                        <#if messagesPerField.existsError('email')>
                            <span id="input-error-email" class="error-message" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('email'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <#if !realm.registrationEmailAsUsername>
                        <div class="form-group">
                            <label for="username">${msg("username")}</label>
                            <div class="input-icon-group">
                                <div class="input-icon">
                                    <i data-lucide="at-sign" class="w-5 h-5"></i>
                                </div>
                                <input type="text" id="username" class="${messagesPerField.printIfExists('username',properties.kcFormGroupErrorClass!)}" name="username"
                                       value="${(register.formData.username!'')}" autocomplete="username"
                                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                                       placeholder="${msg("username")}" required/>
                            </div>
                            <#if messagesPerField.existsError('username')>
                                <span id="input-error-username" class="error-message" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('username'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </#if>

                    <#if passwordRequired??>
                        <div class="form-group">
                            <label for="password">${msg("password")}</label>
                            <div class="input-icon-group">
                                <div class="input-icon">
                                    <i data-lucide="lock" class="w-5 h-5"></i>
                                </div>
                                <input type="password" id="password" class="${messagesPerField.printIfExists('password',properties.kcFormGroupErrorClass!)}" name="password"
                                       autocomplete="new-password"
                                       aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                                       placeholder="${msg("password")}" required/>
                                <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 pr-3 flex items-center" onclick="togglePassword('password')">
                                    <i data-lucide="eye" class="w-5 h-5 text-gray-500 hover:text-gray-300 transition duration-200"></i>
                                </button>
                            </div>
                            <#if messagesPerField.existsError('password')>
                                <span id="input-error-password" class="error-message" aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('password'))?no_esc}
                                </span>
                            </#if>
                        </div>

                        <div class="form-group">
                            <label for="password-confirm">${msg("passwordConfirm")}</label>
                            <div class="input-icon-group">
                                <div class="input-icon">
                                    <i data-lucide="lock" class="w-5 h-5"></i>
                                </div>
                                <input type="password" id="password-confirm" class="${messagesPerField.printIfExists('password-confirm',properties.kcFormGroupErrorClass!)}" name="password-confirm"
                                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                                       placeholder="${msg("passwordConfirm")}" required/>
                                <button type="button" id="toggleConfirmPassword" class="absolute inset-y-0 right-0 pr-3 flex items-center" onclick="togglePassword('password-confirm')">
                                    <i data-lucide="eye" class="w-5 h-5 text-gray-500 hover:text-gray-300 transition duration-200"></i>
                                </button>
                            </div>
                            <#if messagesPerField.existsError('password-confirm')>
                                <span id="input-error-password-confirm" class="error-message" aria-live="polite">
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

                    <div id="kc-form-buttons">
                        <input class="btn btn-primary glow-effect w-full" type="submit" value="${msg("doRegister")}"/>
                    </div>
                </form>

                <!-- Sign In Link -->
                <div class="mt-8 text-center">
                    <p class="text-body-sm">
                        <a href="${url.loginUrl}" class="text-accent font-medium transition duration-200">
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
</script>