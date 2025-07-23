<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${msg("logoutConfirmTitle")}
    <#elseif section = "form">
        <div id="kc-logout-confirm">
            <!-- Logo and Title -->
            <div class="text-center mb-8">
                <div class="flex justify-center mb-4">
                    <div class="bg-gradient-to-r from-yellow-500 to-orange-500 p-3 rounded-2xl">
                        <i data-lucide="log-out" class="w-8 h-8 text-white"></i>
                    </div>
                </div>
                <h1 class="text-2xl font-bold text-white mb-2">${msg("logoutConfirmTitle")}</h1>
                <p class="text-gray-400">${msg("logoutConfirmHeader")}</p>
            </div>

            <!-- Logout Confirmation -->
            <form class="space-y-6" action="${url.logoutConfirmAction}" method="POST">
                <input type="hidden" name="session_state" value="${logoutConfirm.code}">
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <input tabindex="4" 
                           class="btn-primary w-full font-bold py-3 px-4 rounded-lg text-lg shadow-lg hover:shadow-2xl transform hover:scale-105 transition duration-300 ease-in-out glow-effect" 
                           name="confirmLogout" 
                           id="kc-logout" 
                           type="submit" 
                           value="${msg("doLogout")}"/>

                    <button type="button" 
                            onclick="location.href='${url.loginRestartFlowUrl}'"
                            class="glass-effect w-full inline-flex justify-center py-3 px-4 rounded-lg shadow-sm hover:bg-gray-700/30 transition duration-200 text-gray-300 font-bold">
                        ${msg("doCancel")}
                    </button>
                </div>
            </form>
        </div>
    </#if>
</@layout.registrationLayout>
