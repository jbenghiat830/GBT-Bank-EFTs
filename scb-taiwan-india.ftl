<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: SCB-iPaymentCSV -->
<#-- format specific processing -->
<#assign overflowAddr = "">
<#function buildEntityBillingAddress entity>
    <#assign address = "">
    <#if entity.billaddress1?has_content >
        <#if entity.billaddress1?length > 35>
        	<#assign address = entity.billaddress1[0..34]>
        	<#assign overflowAddr = entity.billaddress1[35..]>
        <#else>
        	<#assign address = entity.billaddress1 >
        </#if>
    <#elseif entity.shipaddress1?has_content >
        <#if entity.shipaddress1?length > 35>
        	<#assign address = entity.shipaddress1[0..34]>
        	<#assign overflowAddr = entity.shipaddress1[35..]>
        <#else>
        	<#assign address = entity.shipaddress1 >
        </#if>
    <#elseif entity.address1?has_content >
        <#if entity.address1?length > 35>
        	<#assign address = entity.address1[0..34]>
        	<#assign overflowAddr = entity.address1[35..]>
        <#else>
        	<#assign address = entity.address1 >
        </#if>
    </#if>
    <#return address>
</#function>

<#function getReferenceNote payment>
    <#assign paidTransactions = transHash[payment.internalid]>
    <#if paidTransactions?size == 1>
    	<#assign transaction = paidTransactions[0]>
        <#assign tranId = transaction.tranid>
        <#if tranId?has_content>
	         <#return tranId>
	    </#if> 
    </#if>
	<#return "">
</#function>

<#-- Assign Initial Variables -->
<#assign totalAmount = 0>
<#assign totalPayments = 0>
<#assign recordCount = 0>
<#-- template building -->
#OUTPUT START#
H,P${"\n"}<#rt><#-- Header Record: Record Type=H ; File Type=P -->
<#list payments as payment>
    <#assign ebank = ebanks[payment_index]>
    <#assign entity = entities[payment_index]>
    <#assign amount = getAmount(payment)>
    <#assign totalAmount = totalAmount + amount>
    <#assign totalPayments = totalPayments + 1>
    <#assign recordCount = recordCount + 1>
<#--P01-->P,<#rt>
<#if payment.class == "Taiwan">
<#--P02-->RTGS,<#rt><#--TT=Telegraphic Transfer;RTGS=Wire Payments;CC=Corporate Cheque;Taiwan EFT=RTGS;Taiwan Wire=TT-->
<#--P03-->ON,<#rt><#--If RTGS or TT=ON, ACH=BA-->
<#elseif payment.class == "India">
<#--P02-->ACH,<#rt><#--TT=Telegraphic Transfer;RTGS=Wire Payments;CC=Corporate Cheque;Taiwan EFT=RTGS;Taiwan Wire=TT-->
<#--P03-->BA,<#rt><#--If RTGS or TT=ON, ACH=BA-->
<#else>
<#--P02-->ACH,<#rt><#--TT=Telegraphic Transfer;RTGS=Wire Payments;CC=Corporate Cheque;Taiwan EFT=RTGS;Taiwan Wire=TT-->
<#--P03-->BA,<#rt><#--If RTGS or TT=ON, ACH=BA-->
</#if>
<#--P04-->,<#rt><#--Not Used-->
<#--P05-->${setMaxLength(getReferenceNote(payment),16)},<#rt>
<#--P06-->${setMaxLength(payment.memomain,18)},<#rt>
<#if payment.class == "Taiwan">
<#--P07-->TW,<#rt><#--Debit Country Code (TW)-->
<#--P08-->TPE,<#rt><#--Debit City Code (TPE)-->
<#elseif payment.class == "India">
<#--P07-->IN,<#rt><#--Debit Country Code (IN)-->
<#--P08-->BOM,<#rt><#--Debit City Code (BOM)-->
</#if>
<#--P09-->${setMaxLength(cbank.custpage_eft_custrecord_2663_acct_num,34)},<#rt><#--Bank Account Number-->
<#--P10-->${setMaxLength(pfa.custrecord_2663_file_creation_timestamp?string("dd/MM/yyyy"),10)},<#rt>
<#--P11-->"${setMaxLength(buildEntityName(entity,false),35)}",<#rt><#--Payee Name-->
<#if entity.custentitycustentity_gbt__payment_method == "check">
<#--P12-->${buildEntityBillingAddress(entity)},<#rt><#--Payee Address1-->
<#--P13-->${overflowAddr},<#rt><#--Payee Address2-->
<#--P14-->,<#rt><#--Payee Address3-->
<#else>
<#--P12-->,<#rt><#--Payee Address1-->
<#--P13-->,<#rt><#--Payee Address2-->
<#--P14-->,<#rt><#--Payee Address3-->
</#if>
<#--P15-->,<#rt><#--Not Used-->
<#--P16-->${setMaxLength(ebank.custrecord_2663_entity_bank_no,17)},<#rt><#--Payee Bank Code/Branch Code (Taiwan); IFSC Code (India)-->
<#--P17-->,<#rt><#--Not Used-->
<#--P18-->,<#rt><#--Not Used--><#--Payee Branch Code-->
<#--P19-->,<#rt><#--Not Used-->
<#--P20-->${setMaxLength(ebank.custrecord_2663_entity_acct_no,34)},<#rt><#--Payee Account Number-->
<#--P21-->,<#rt><#--Not Used--><#--Payment Description on Checks (70)-->
<#--P22-->,<#rt><#--Not Used--><#--Payment Description on Checks (70)-->
<#--P23-->,<#rt><#--Not Used-->
<#--P24-->,<#rt><#--Not Used-->
<#--P25-->,<#rt><#--Not Used-->
<#--P26-->,<#rt><#--Not Used-->
<#--P27-->,<#rt><#--Not Used-->
<#--P28-->,<#rt><#--Not Used-->
<#--P29-->,<#rt><#--Not Used-->
<#--P30-->,<#rt><#--Not Used-->
<#--P31-->,<#rt><#--Not Used-->
<#--P32-->,<#rt><#--Not Used-->
<#--P33-->,<#rt><#--Not Used-->
<#--P34-->,<#rt><#--Not Used-->
<#--P35-->,<#rt><#--Not Used-->
<#--P36-->,<#rt><#--Not Used-->
<#--P37-->,<#rt><#--Not Used-->
<#--P38-->${getCurrencySymbol(payment.currency)},<#rt><#--Payment Currency-->
<#--P39-->${setMaxLength(formatAmount(amount,"dec"),14)},<#rt><#--Payment Amount-->
<#--P40-->C,<#rt><#--Local Charges To-->
<#--P41-->C,<#rt><#--Overseas Charges To-->
<#--P42-->,<#rt><#--Not Used--><#--Intermediary Bank Code (Swift Code)-->
<#--P43-->,<#rt><#--Not Used--><#--Clearing Code for TT-->
<#--P44-->,<#rt><#--Not Used--><#--Clearing Zone Code for LBC-->
<#--P45-->,<#rt><#--Not Used--><#--For IBC Only-->
<#if entity.custentitycustentity_gbt__payment_method == "check">
<#--P46-->C,<#rt><#--Delivery Method: M=Mail;C=Courier;P=Pickup-->
<#--P47-->P,<#rt><#--Deliver To: C=GBT;P=Payee-->
<#--P48-->,<#rt><#--For LBC,CC. If Delivery method & Delivery to is “P” then this field needs to be indicated on where the cheques are to be picked up-->
<#else>
<#--P46-->,<#rt><#--Delivery Method: M=Mail;C=Courier;P=Pickup-->
<#--P47-->,<#rt><#--Deliver To: C=GBT;P=Payee-->
<#--P48-->,<#rt><#--For LBC,CC. If Delivery method & Delivery to is “P” then this field needs to be indicated on where the cheques are to be picked up-->
</#if>
<#--P49-->,<#rt>
<#--P50-->,<#rt><#--Payee Name in Local Language-->
<#--P51-->,<#rt>
<#--P52-->,<#rt>
<#--P53-->,<#rt>
<#--P54-->,<#rt>
<#--P55-->,<#rt>
<#--P56-->,<#rt>
<#--P57-->,<#rt>
<#--P58-->,<#rt>
<#--P59-->,<#rt>
<#--P60-->,<#rt><#--Debit Currency-->
<#if payment.class == "Taiwan">
<#--P61-->SCBLTWTPXXX,<#rt><#--Debit Bank ID (R) (SCBLTWTPXXX or SCBLINBBXXX)-->
<#elseif payment.class == "India">
<#--P61-->SCBLINBBXXX,<#rt><#--Debit Bank ID (R) (SCBLTWTPXXX or SCBLINBBXXX)-->
<#else>
<#--P61-->Missing Debit Bank ID,<#rt><#--Debit Bank ID (R) (SCBLTWTPXXX or SCBLINBBXXX)-->
</#if>
<#--P62-->,<#rt>
<#--P63--><#rt><#--Email ID-->
${"\n"}<#--Line Break--><#rt>
</#list>
T,${setMaxLength(recordCount,5)},${setMaxLength(formatAmount(totalAmount,"dec"),14)}<#rt>
#OUTPUT END#
