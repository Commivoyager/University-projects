#include "..\pch.h"
#include "TableCell.h"

void TableCell::chngEditability() {
	if (isEditable) {
		isEditable = FALSE;
	}
	else {
		isEditable = TRUE;
	}
}