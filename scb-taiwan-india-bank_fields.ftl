<#-- Reference Fields -->
<refFields type="SCB-iPaymentCSV">
<refField id='custrecord_2663_acct_num' label="Account Number" mandatory='false' helptext="Enter your company's bank account number."/>
</refFields>

<#-- Entity Fields -->
<refFields type='SCB-iPaymentCSV'>
  <refField id='custrecord_2663_entity_bank_no' label='Payee Bank Code/IFSC Code' mandatory='false' />
  <refField id='custrecord_2663_entity_acct_no' label='Payee Bank Account Number' mandatory='false' />
</refFields>
<#-- India Only- IFSC, Bank Account Number-->
<#--Taiwan Only- Bank Code = Bank/Branch Code 7 digits - 0051234-->

<#-- Field Validator -->
<fieldValidatorList>
<#-- No validator at this moment -->
</fieldValidatorList>