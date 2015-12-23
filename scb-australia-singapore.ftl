<#-- Author: Michael Wang | mwang@netsuite.com -->
<#-- Bank Format: SCB-iPaymentCSV for Australia/Singapore MT101-->
<#-- format specific processing -->
<#assign overflowAddr = "">
<#function buildEntityBillingAddress entity>
    <#assign address = "">
    <#if entity.billaddress1?has_content >
        <#if (entity.billaddress1?length > 35) >
        	<#assign address = entity.billaddress1?substring(0, 35)>
        	<#assign overflowAddr = entity.billaddress1?substring(35)>
        <#else>
        	<#assign address = entity.billaddress1 >
        </#if>
    <#elseif entity.shipaddress1?has_content >
        <#if (entity.shipaddress1?length > 35) >
        	<#assign address = entity.shipaddress1?substring(0, 35)>
        	<#assign overflowAddr = entity.shipaddress1?substring(35)>
        <#else>
        	<#assign address = entity.shipaddress1 >
        </#if>
    <#elseif entity.address1?has_content >
        <#if (entity.address1?length > 35) >
        	<#assign address = entity.address1?substring(0, 35)>
        	<#assign overflowAddr = entity.address1?substring(35)>
        <#else>
        	<#assign address = entity.address1 >
        </#if>
    </#if>
    <#return address>
</#function>

<#function trimBankCountry str>
	<#if str?ends_with(" - AU") || str?ends_with(" - SG")>
		<#return str?substring(0, str?length-5)>
	</#if>
	
	<#if str?ends_with("-AU") || str?ends_with("-SG")>
		<#return str?substring(0, str?length-3)>
	</#if>
	
	<#if str?ends_with("- AU") || str?ends_with("- SG")>
		<#return str?substring(0, str?length-4)>
	</#if>
</#function>

<#function validateSwift str>
	<#return str?matches('^([0-9]{11})?$')>
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
<#-- Identify Country -->
<#if payment.class == "Australia">
	<#assign bankCountry = "AU">
<#elseif payment.class == "Singapore">
	<#assign bankCountry = "SG">
</#if>
<#--P01-->P,<#rt>
<#-- AU/SG Payments are all RFT/ON and MT/101-->
<#--P02-->RFT,<#rt>
<#--P03-->ON,<#rt>
<#--P04-->,<#rt><#--Not Used-->
<#--P05-->${setMaxLength(payment.tranid,16)},<#rt>
<#--P06-->,<#rt><#--Not Used-->
<#--P07-->MT,<#rt><#--Debit Country Code (MT)-->
<#--P08-->101,<#rt><#--Debit City Code (101)-->
<#if bankCountry == "AU">
<#--P09-->"${setMaxLength(cbank.custpage_eft_custrecord_2663_acct_num,34)}",<#rt><#--Bank Account Number-->
<#else>
<#--P09-->${setMaxLength(cbank.custpage_eft_custrecord_2663_acct_num,34)},<#rt><#--Bank Account Number-->
</#if>
<#--P10-->${setMaxLength(pfa.custrecord_2663_process_date?string("dd/MM/yyyy"),10)},<#rt>
<#--P11-->"${setMaxLength(trimBankCountry(buildEntityName(entity, false)),35)}",<#rt><#--Payee Name-->
<#--P12-->,<#rt><#--Payee Address1-->
<#--P13-->,<#rt><#--Payee Address2-->
<#--P14-->,<#rt><#--Payee Address3-->
<#--P15-->,<#rt><#--Not Used-->
<#--P16-->${setMaxLength(ebank.custrecord_2663_entity_bank_code,17)},<#rt><#--Payee Swift Code-->
<#--P17-->,<#rt><#--Not Used-->
<#--P18-->,<#rt><#--Not Used--><#--Payee Branch Code-->
<#--P19-->,<#rt><#--Not Used-->
<#--P20-->${setMaxLength(ebank.custrecord_2663_entity_acct_no,34)},<#rt><#--Payee Account Number-->
<#--P21-->,<#rt><#--Not Used--><#--Payment Description on Check Payments (70)-->
<#--P22-->,<#rt><#--Not Used--><#--Payment Description on Check Payments (70)-->
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
<#--P46-->,<#rt><#--Delivery Method: M=Mail;C=Courier;P=Pickup-->
<#--P47-->,<#rt><#--Deliver To: C=GBT;P=Payee-->
<#--P48-->,<#rt><#--For LBC,CC. If Delivery method & Delivery to is 「P」 then this field needs to be indicated on where the cheques are to be picked up-->
<#if cbank.custrecord_2663_currency != payment.currency>
<#--P49-->S,<#rt><#--FX Type: Applicable only if payment and debit account currencies are different. S=System Rate-->
<#else>
<#--P49-->,<#rt><#--FX Type: Not Required-->
</#if>
<#--P50-->,<#rt><#--Not Used-->
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
<#if bankCountry == "AU">
<#--P61-->NATAAU33XXX,<#rt><#--Debit Bank ID (R)-->
<#elseif bankCountry == "SG">
<#--P61-->UOVBSGSGXXX,<#rt><#--Debit Bank ID (R)-->
</#if>
<#--P62-->,<#rt>
<#--P63-->${entity.email},<#rt><#--Email ID-->
<#--P64-->,<#rt>
<#--P65-->SW,<#rt><#--Beneficiary Bank Type (SW for RFT Payments)-->
<#--P66-->,<#rt>
<#--P67-->,<#rt>
<#--P68-->,<#rt>
<#--P69-->,<#rt>
<#--P70-->,<#rt>
<#--P71-->,<#rt>
<#--P72-->,<#rt>
<#--P73-->${setMaxLength(payment.tranid,16)},<#rt><#--MT101 Related Information: Same as Field 5-Customer Reference-->
${"\n"}<#--Line Break--><#rt>
</#list>
T,${setMaxLength(recordCount,5)},${setMaxLength(formatAmount(totalAmount,"dec"),14)}<#rt>
#OUTPUT END#
