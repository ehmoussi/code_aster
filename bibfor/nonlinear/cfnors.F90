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

subroutine cfnors(noma, ds_contact, posmai, typent,&
                  nument, lpoutr, lpoint, ksi1, ksi2,&
                  lliss, itype, vector, tau1, tau2,&
                  lnfixe)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfnord.h"
#include "asterfort/copnor.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: posmai
    type(NL_DS_Contact), intent(in) :: ds_contact
    real(kind=8) :: ksi1, ksi2
    character(len=8) :: noma
    character(len=4) :: typent
    integer :: nument
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: vector(3)
    integer :: itype
    aster_logical :: lnfixe, lliss, lpoutr, lpoint
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - APPARIEMENT)
!
! CHANGE LES VECTEURS TANGENTS LOCAUX QUAND NORMALE DONNEE PAR
! UTILISATEUR OU LISSAGE
!
! ----------------------------------------------------------------------
!
!  NB: LE REPERE EST ORTHORNORME ET TEL QUE LA NORMALE POINTE VERS
!  L'EXTERIEUR DE LA MAILLE
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  POSMAI : MAILLE QUI RECOIT LA PROJECTION
! IN  LLISS  : IL FAUT FAIRE LE LISSAGE
! IN  LPOUTR : MAILLE DE TYPE POUTRE
! IN  LPOINT : MAILLE DE TYPE POINT (POI1)
! IN  TYPENT : TYPE DE L'ENTITE
!               'MAIL' UNE MAILLE
!               'NOEU' UN NOEUD
! IN  NUMENT : NUMERO ABSOLU DE L'ENTITE DANS LE MAILLAGE
! IN  ITYPE  : TYPE DE NORMALE
!                0 AUTO
!                1 FIXE   (DONNE PAR VECTOR)
!                2 VECT_Y (DONNE PAR VECTOR)
! IN  VECTOR : VALEUR DE LA NORMALE FIXE OU VECT_Y
! IN  KSI1   : COORDONNEE X DU POINT PROJETE
! IN  KSI2   : COORDONNEE Y DU POINT PROJETE
! In  ds_contact       : datastructure for contact management
! I/O TAU1   : PREMIERE TANGENTE LOCALE AU POINT PROJETE
! I/O TAU2   : SECONDE TANGENTE LOCALE AU POINT PROJETE
! OUT LNFIXE : VAUT .TRUE. SI NORMALE='FIXE' OU 'VECT_Y'
!                   .FALSE. SI NORMALE='AUTO'
!
!
!
!
    character(len=8) :: noment
!
! ----------------------------------------------------------------------
!
!
! --- NOM DE L'ENTITE (NOEUD OU MAILLE)
!
    if (typent .eq. 'MAIL') then
        call jenuno(jexnum(noma//'.NOMMAI', nument), noment)
    else if (typent.eq.'NOEU') then
        call jenuno(jexnum(noma//'.NOMNOE', nument), noment)
    else
        ASSERT(.false.)
    endif
!
! --- MODIF DE LA NORMALE SI FIXE (LNFIXE = .TRUE.)
!
    call cfnord(noma, typent, nument, itype, vector,&
                tau1, tau2, lnfixe)
!
! --- VERIFICATION POUTRES
!
    if (lpoutr) then
        if (.not.lnfixe) then
            if (typent .eq. 'MAIL') then
                call utmess('F', 'CONTACT_60', sk=noment)
            else if (typent.eq.'NOEU') then
                call utmess('F', 'CONTACT_61', sk=noment)
            else
                ASSERT(.false.)
            endif
        endif
    endif
!
! --- VERIFICATION MAILLE POINT
!
    if (lpoint) then
        if (.not.lnfixe) then
            call utmess('F', 'CONTACT3_60', sk=noment)
        endif
    endif
!
! --- LISSAGE DES VECTEURS TANGENTS
!
    if (lliss) then
        if (lnfixe) then
            ASSERT(.false.)
        endif
        if (typent .eq. 'MAIL') then
            call copnor(noma, ds_contact, posmai, ksi1,&
                        ksi2, tau1, tau2)
        else
            ASSERT(.false.)
        endif
    endif
!
end subroutine
