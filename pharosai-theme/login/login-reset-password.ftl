<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <div id="kc-form">
            <div id="kc-form-wrapper">
                
                <!-- Logo and Title -->
                <div class="text-center mb-8">
                    <div class="flex justify-center mb-4">
                        <div class="bg-gradient-warning p-3 rounded-2xl">
                            <i data-lucide="key" class="w-8 h-8 text-white"></i>
                        </div>
                    </div>
                    <h1 class="heading-2 mb-2">${msg("emailForgotTitle")}</h1>
                    <p class="text-body-sm">${msg("emailInstruction")}</p>
                </div>

                <!-- Reset Password Form -->
                <form id="kc-reset-password-form" class="space-y-6" action="${url.loginAction}" method="post">
                    <div class="form-group">
                        <label for="username"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>

                        <div class="input-icon-group">
                            <div class="input-icon">
                                <i data-lucide="<#if realm.loginWithEmailAllowed>mail<#else>user</#if>" class="w-5 h-5"></i>
                            </div>
                            <input type="text" id="username" name="username" class="${messagesPerField.printIfExists('username',properties.kcFormGroupErrorClass!)}" autofocus value="${(auth.attemptedUsername!'')}"
                                   aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                                   placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>" required/>
                        </div>

                        <#if messagesPerField.existsError('username')>
                            <span id="input-error-username" class="error-message" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('username'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="space-y-4">
                        <div id="kc-form-buttons">
                            <input class="btn btn-primary glow-effect w-full" type="submit" value="${msg("doSubmit")}"/>
                        </div>

                        <div id="kc-form-options">
                            <div>
                                <a href="${url.loginUrl}" class="btn btn-glass w-full">
                                    ${kcSanitize(msg("backToLogin"))?no_esc}
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
