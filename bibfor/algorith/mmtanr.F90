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

subroutine mmtanr(mesh, model_ndim, ds_contact, i_zone,&
                  lexfro, node_slav_indx, ksi1, ksi2, elem_mast_indx,&
                  elem_mast_nume, tau1m, tau2m, tau1, tau2)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cftanr.h"
#include "asterfort/mmexfr.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8) :: mesh
    integer :: i_zone
    integer :: model_ndim
    integer :: node_slav_indx, elem_mast_indx, elem_mast_nume
    real(kind=8) :: ksi1, ksi2
    type(NL_DS_Contact), intent(in) :: ds_contact
    real(kind=8) :: tau1m(3), tau2m(3)
    real(kind=8) :: tau1(3), tau2(3)
    aster_logical :: lexfro
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
!
! MOD. LES VECTEURS TANGENTS LOCAUX SUIVANT OPTIONS
!
! ----------------------------------------------------------------------
!
! IN  NOMA   : NOM DU MAILLAGE
! In  ds_contact       : datastructure for contact management
! IN  NDIMG  : DIMENSION DE L'ESPACE
! IN  IZONE  : ZONE DE CONTACT ACTIVE
! IN  LEXFRO : LE POINT D'INTEGRATION DOIT-IL ETRE EXCLUS DU FROTTEMENT?
! IN  POSMAM : POSITION DE LA MAILLE MAITRE DANS LES SD CONTACT
! IN  NUMMAM : NUMERO ABSOLU MAILLE MAITRE QUI RECOIT LA PROJECTION
! IN  POSNOE : POSITION DU PT INTEG DANS LES SD CONTACT SI INTEG.NOEUDS
! IN  KSI1   : PREMIERE COORDONNEE PARAMETRIQUE PT CONTACT PROJETE
!              SUR MAILLE MAITRE
! IN  KSI2   : SECONDE COORDONNEE PARAMETRIQUE PT CONTACT PROJETE
!              SUR MAILLE MAITRE
! IN  TAU1M  : PREMIERE TANGENTE SUR LA MAILLE MAITRE AU POINT ESCLAVE
!              PROJETE
! IN  TAU2M  : SECONDE TANGENTE SUR LA MAILLE MAITRE AU POINT ESCLAVE
!              PROJETE
! OUT TAU1   : PREMIERE TANGENTE LOCALE AU POINT ESCLAVE PROJETE
! OUT TAU2   : SECONDE TANGENTE LOCALE AU POINT ESCLAVE PROJETE
!
! ----------------------------------------------------------------------
!
    ASSERT(elem_mast_nume.gt.0)
!
! --- CHOIX DE LA NORMALE
!
    call cftanr(mesh, model_ndim, ds_contact, i_zone,&
                node_slav_indx, 'MAIL', elem_mast_indx, elem_mast_nume, ksi1,&
                ksi2, tau1m, tau2m, tau1, tau2)
!
! --- REPERE LOCAL TANGENT AVEC SANS_GROUP_NO_FR -> FIXE
!
    if (lexfro) then
        call mmexfr(mesh, ds_contact, i_zone, elem_mast_indx, tau1,&
                    tau2)
    endif
!
end subroutine
