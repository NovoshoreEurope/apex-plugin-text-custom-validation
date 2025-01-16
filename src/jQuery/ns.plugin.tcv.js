var textCustomValidation = {
    name: null, // Property to store the name of the item.

    _initialize: function (short_text, itemName) {
        "use strict";

        this._initMessages();

        const self = this; // Capturar el contexto actual de textCustomValidation.

        // Override Apex's getValidity method to validate the item's value.
        apex.item(itemName).getValidity = function () {
            // Initialize validity object with default values.
            var lValidity = {
                valid: true,
                empty: false,
                startsWithError: false
            };
            let value = $v(itemName); // Get the item's value.

            // Check if the value is empty.
            if (!value || value.trim() === "") {
                lValidity.valid = false;
                lValidity.empty = true; // Mark as empty.
            }
            // If not empty, check if it starts with the required text.
            else if (!value.startsWith(short_text)) {
                lValidity.valid = false;
                lValidity.startsWithError = true; // Mark as a prefix error.
            }

            return lValidity; // Return the validity object.
        };

        // Override Apex's getValidationMessage method to provide user-friendly messages.
        apex.item(itemName).getValidationMessage = function () {
            const validity = this.getValidity(); // Reuse getValidity to get the state.

            if (validity.empty) {
                return apex.lang.getMessage(self._getMessage('IS_EMPTY'));
            }
            if (validity.startsWithError) {
                return apex.lang.formatMessage(self._getMessage('IS_START_INCORRECT'), short_text);
            }
            if (!validity.valid) {
                return apex.lang.getMessage(self._getMessage('IS_INVALID'));
            }
            return ""; // Return an empty string if valid.
        };
    },

    _initMessages: function () {
        // here we have the labels and messages for which the developer should be 
        // able to config translations in APEX
        apex.lang.addMessages({
            'NS.TCV.IS_EMPTY': "This item cannot be empty",
            'NS.TCV.IS_INVALID': "The value entered is not valid",
            'NS.TCV.IS_START_INCORRECT': "The value must start with the prefix '%0'."
        });
    },

    _getMessage: function (key) {
        return apex.lang.getMessage('NS.TCV.' + key);
    },

    // Method to get the current value of the item associated with `name`.
    value: function () {
        return $v(this.name); // Return the value using Apex.
    }
};