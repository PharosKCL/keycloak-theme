<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${msg("logoutConfirmTitle")}
    <#elseif section = "form">
        <div id="kc-logout-confirm">
            <!-- Logo and Title -->
            <div class="text-center mb-8">
                <div class="flex justify-center mb-4">
                    <div class="bg-gradient-warning p-3 rounded-2xl">
                        <i data-lucide="log-out" class="w-8 h-8 text-white"></i>
                    </div>
                </div>
                <h1 class="heading-2 mb-2">${msg("logoutConfirmTitle")}</h1>
                <p class="text-body-sm">${msg("logoutConfirmHeader")}</p>
            </div>

            <!-- Logout Confirmation -->
            <form class="space-y-6" action="${url.logoutConfirmAction}" method="POST">
                <input type="hidden" name="session_state" value="${logoutConfirm.code}">
                
                <div class="form-grid cols-2">
                    <input tabindex="4" 
                           class="btn btn-primary glow-effect w-full" 
                           name="confirmLogout" 
                           id="kc-logout" 
                           type="submit" 
                           value="${msg("doLogout")}"/>

                    <button type="button" 
                            onclick="location.href='${url.loginRestartFlowUrl}'"
                            class="btn btn-glass w-full">
                        ${msg("doCancel")}
                    </button>
                </div>
            </form>
        </div>
    </#if>
</@layout.registrationLayout>
