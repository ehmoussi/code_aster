! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

function ndynre(sddyna, chaine)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    real(kind=8) :: ndynre
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=19) :: sddyna
    character(len=*) :: chaine
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (SDDYNA - UTILITAIRE)
!
! INTERROGE SDDYNA POUR RENVOYER UN REEL
!
! ----------------------------------------------------------------------
!
!
! OUT NDYNRE : PARAMETRE REEL DE L'OBJET .PARA_SCHEMA DEMANDE
! IN  SDDYNA : NOM DE LA SD DEDIEE A LA DYNAMIQUE
! IN  CHAINE : NOM DU PARAMETRE
!
! ----------------------------------------------------------------------
!
    real(kind=8), pointer :: coef_sch(:) => null()
    real(kind=8), pointer :: para_sch(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    call jeveuo(sddyna(1:15)//'.PARA_SCH', 'L', vr=para_sch)
    call jeveuo(sddyna(1:15)//'.COEF_SCH', 'L', vr=coef_sch)
!
    if (chaine .eq. 'BETA') then
        ndynre = para_sch(1)
    else if (chaine.eq.'GAMMA') then
        ndynre = para_sch(2)
    else if (chaine.eq.'PHI') then
        ndynre = para_sch(3)
    else if (chaine.eq.'COEF_MASS_SHIFT') then
        ndynre = para_sch(6)
    else if (chaine.eq.'ALPHA') then
        ndynre = para_sch(7)
!
    else if (chaine.eq.'COEF_MATR_RIGI') then
        ndynre = coef_sch(1)
    else if (chaine.eq.'COEF_MATR_AMOR') then
        ndynre = coef_sch(2)
    else if (chaine.eq.'COEF_MATR_MASS') then
        ndynre = coef_sch(3)
!
    else if (chaine.eq.'COEF_DEPL_DEPL') then
        ndynre = coef_sch(4)
    else if (chaine.eq.'COEF_DEPL_VITE') then
        ndynre = coef_sch(5)
    else if (chaine.eq.'COEF_DEPL_ACCE') then
        ndynre = coef_sch(6)
    else if (chaine.eq.'COEF_VITE_DEPL') then
        ndynre = coef_sch(7)
    else if (chaine.eq.'COEF_VITE_VITE') then
        ndynre = coef_sch(8)
    else if (chaine.eq.'COEF_VITE_ACCE') then
        ndynre = coef_sch(9)
    else if (chaine.eq.'COEF_ACCE_DEPL') then
        ndynre = coef_sch(10)
    else if (chaine.eq.'COEF_ACCE_VITE') then
        ndynre = coef_sch(11)
    else if (chaine.eq.'COEF_ACCE_ACCE') then
        ndynre = coef_sch(12)
!
    else if (chaine.eq.'COEF_DEPL') then
        ndynre = coef_sch(13)
    else if (chaine.eq.'COEF_VITE') then
        ndynre = coef_sch(14)
    else if (chaine.eq.'COEF_ACCE') then
        ndynre = coef_sch(15)
!
    else if (chaine.eq.'COEF_MPAS_FEXT_PREC') then
        ndynre = coef_sch(16)
    else if (chaine.eq.'COEF_MPAS_EQUI_COUR') then
        ndynre = coef_sch(17)
    else if (chaine.eq.'COEF_MPAS_FINT_PREC') then
        ndynre = coef_sch(18)
    else if (chaine.eq.'COEF_MPAS_FEXT_COUR') then
        ndynre = coef_sch(19)
!
    else if (chaine.eq.'COEF_FDYN_MASSE') then
        ndynre = coef_sch(20)
    else if (chaine.eq.'COEF_FDYN_AMORT') then
        ndynre = coef_sch(21)
    else if (chaine.eq.'COEF_FDYN_RIGID') then
        ndynre = coef_sch(22)
!
    else if (chaine.eq.'COEF_FORC_INER') then
        ndynre = coef_sch(23)
    else if (chaine.eq.'INST_PREC') then
        ndynre = coef_sch(24)
!
    else
        ASSERT(.false.)
    endif
!
    call jedema()
!
end function
