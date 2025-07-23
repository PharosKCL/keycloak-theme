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
                        <div class="bg-gradient-to-r from-yellow-500 to-orange-500 p-3 rounded-2xl">
                            <i data-lucide="key" class="w-8 h-8 text-white"></i>
                        </div>
                    </div>
                    <h1 class="text-2xl font-bold text-white mb-2">${msg("emailForgotTitle")}</h1>
                    <p class="text-gray-400">${msg("emailInstruction")}</p>
                </div>

                <!-- Reset Password Form -->
                <form id="kc-reset-password-form" class="space-y-6" action="${url.loginAction}" method="post">
                    <div class="${properties.kcFormGroupClass!}">
                        <label for="username" class="block text-sm font-medium text-gray-300 mb-2"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>

                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i data-lucide="<#if realm.loginWithEmailAllowed>mail<#else>user</#if>" class="w-5 h-5 text-gray-500"></i>
                            </div>
                            <input type="text" id="username" name="username" class="input-field w-full pl-10 pr-4 py-3 rounded-lg text-white placeholder-gray-500 focus:outline-none ${messagesPerField.printIfExists('username',properties.kcFormGroupErrorClass!)}" autofocus value="${(auth.attemptedUsername!'')}"
                                   aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                                   placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"/>
                        </div>

                        <#if messagesPerField.existsError('username')>
                            <span id="input-error-username" class="text-red-400 text-sm mt-1" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('username'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="${properties.kcFormGroupClass!} ${properties.kcFormSettingClass!} space-y-4">
                        <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                            <input class="btn-primary w-full font-bold py-3 px-4 rounded-lg text-lg shadow-lg hover:shadow-2xl transform hover:scale-105 transition duration-300 ease-in-out glow-effect" type="submit" value="${msg("doSubmit")}"/>
                        </div>

                        <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                            <div class="${properties.kcFormOptionsWrapperClass!}">
                                <a href="${url.loginUrl}" class="glass-effect w-full inline-flex justify-center py-3 px-4 rounded-lg shadow-sm hover:bg-gray-700/30 transition duration-200 text-gray-300">
                                    <i data-lucide="arrow-left" class="w-5 h-5 mr-2"></i>
                                    ${kcSanitize(msg("backToLogin"))?no_esc}
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    <#elseif section = "info" >
        ${msg("emailInstructionUsername")<#if realm.duplicateEmailsAllowed>, ${msg("emailInstructionEmail")}</#if>.
    </#if>
</@layout.registrationLayout>
