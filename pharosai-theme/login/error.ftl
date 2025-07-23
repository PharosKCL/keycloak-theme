<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${msg("errorTitle")}
    <#elseif section = "form">
        <div id="kc-error-message">
            <!-- Logo and Title -->
            <div class="text-center mb-8">
                <div class="flex justify-center mb-4">
                    <div class="bg-gradient-to-r from-red-500 to-red-600 p-3 rounded-2xl">
                        <i data-lucide="alert-triangle" class="w-8 h-8 text-white"></i>
                    </div>
                </div>
                <h1 class="text-2xl font-bold text-white mb-2">${msg("errorTitle")}</h1>
                <#if client?? && client.baseUrl?has_content>
                    <p class="text-gray-400 mb-6">${msg("errorTitleHtml")?no_esc}</p>
                <#else>
                    <p class="text-gray-400 mb-6">${message.summary}</p>
                </#if>
            </div>

            <!-- Error Message -->
            <div class="mb-8 p-4 rounded-lg border border-red-500 bg-red-900/20">
                <div class="flex items-center">
                    <i data-lucide="x-circle" class="w-5 h-5 text-red-400 mr-3"></i>
                    <p class="text-red-200">${message.summary?no_esc}</p>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="space-y-4">
                <#if client?? && client.baseUrl?has_content>
                    <a href="${client.baseUrl}" 
                       class="btn-primary w-full font-bold py-3 px-4 rounded-lg text-lg shadow-lg hover:shadow-2xl transform hover:scale-105 transition duration-300 ease-in-out glow-effect text-center block">
                        ${kcSanitize(msg("backToApplication"))?no_esc}
                    </a>
                </#if>
                
                <a href="${url.loginUrl}" 
                   class="glass-effect w-full inline-flex justify-center py-3 px-4 rounded-lg shadow-sm hover:bg-gray-700/30 transition duration-200 text-gray-300">
                    <i data-lucide="arrow-left" class="w-5 h-5 mr-2"></i>
                    ${msg("backToLogin")}
                </a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>

<script>
// Initialize icons when document loads
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