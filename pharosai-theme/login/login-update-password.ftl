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
                        <div class="bg-gradient-success p-3 rounded-2xl">
                            <i data-lucide="shield-check" class="w-8 h-8 text-white"></i>
                        </div>
                    </div>
                    <h1 class="heading-2 mb-2">${msg("updatePasswordTitle")}</h1>
                    <p class="text-body-sm">${msg("updatePasswordMsg")}</p>
                </div>

                <!-- Update Password Form -->
                <form id="kc-passwd-update-form" class="space-y-6" action="${url.loginAction}" method="post">
                    <div class="form-group">
                        <label for="password-new">${msg("passwordNew")}</label>
                        <div class="input-icon-group">
                            <div class="input-icon">
                                <i data-lucide="lock" class="w-5 h-5"></i>
                            </div>
                            <input type="password" id="password-new" name="password-new" class="${messagesPerField.printIfExists('password',properties.kcFormGroupErrorClass!)}"
                                   autofocus autocomplete="new-password"
                                   aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                                   placeholder="${msg("passwordNew")}" required/>
                            <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 pr-3 flex items-center" onclick="togglePassword('password-new')">
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
                            <input type="password" id="password-confirm" name="password-confirm" class="${messagesPerField.printIfExists('password-confirm',properties.kcFormGroupErrorClass!)}"
                                   autocomplete="new-password"
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

                    <#if isAppInitiatedAction??>
                        <input class="btn btn-primary glow-effect w-full mb-4" type="submit" value="${msg("doSubmit")}" />
                        <button class="btn btn-glass w-full" type="submit" name="cancel-aia" value="true" formnovalidate>
                            ${msg("doCancel")}
                        </button>
                    <#else>
                        <input class="btn btn-primary glow-effect w-full" type="submit" value="${msg("doSubmit")}" />
                    </#if>
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