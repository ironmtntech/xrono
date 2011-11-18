// from http://www.smipple.net/snippet/insin/jQuery.fn.disableTextSelection
/**
 * Prevents click-based selectiion of text in all matched elements.
 */
jQuery.fn.disableTextSelection = function()
{
    return this.each(function()
    {
        if (typeof this.onselectstart != "undefined") // IE
        {
            this.onselectstart = function() { return false; };
        }
        else if (typeof this.style.MozUserSelect != "undefined") // Firefox
        {
            this.style.MozUserSelect = "none";
        }
        else // All others
        {
            this.onmousedown = function() { return false; };
            this.style.cursor = "default";
        }
    });
};
