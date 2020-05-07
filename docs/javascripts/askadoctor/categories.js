function ShowProcedures(specialtyId)
{
	$(".specialty" + specialtyId).show();
	$(".SeeAll" + specialtyId).hide();
	$(".HideAll" + specialtyId).show();

}

function HideProcedures(specialtyId)
{
	$(".specialty" + specialtyId).hide();
	$(".SeeAll" + specialtyId).show();
	$(".HideAll" + specialtyId).hide();
}