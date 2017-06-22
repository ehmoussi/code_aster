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

subroutine nmchfi(ds_algopara, fonact    , sddisc, sddyna, numins,&
                  iterat     , ds_contact, lcfint, lcdiri, lcbudi,&
                  lcrigi     , option)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchrm.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_AlgoPara), intent(in) :: ds_algopara
    integer :: fonact(*)
    character(len=16) :: option
    character(len=19) :: sddisc, sddyna
    integer :: numins, iterat
    type(NL_DS_Contact), intent(in) :: ds_contact
    aster_logical :: lcfint, lcrigi, lcdiri, lcbudi
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! CHOIX DE L'OPTION POUR CALCUL DES FORCES INTERNES
!
! ----------------------------------------------------------------------
!
! In  ds_algopara      : datastructure for algorithm parameters
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  SDDISC : SD DISC_INST
! IN  SDDYNA : SD DYNAMIQUE
! IN  NUMINS : NUMERO D'INSTANT
! IN  ITERAT : NUMERO D'ITERATION
! In  ds_contact       : datastructure for contact management
! OUT LCFINT  : .TRUE. SI CALCUL DES VECT_ELEM DES FORCES INTERIEURS
! OUT LCDIRI  : .TRUE. SI CALCUL DES VECT_ELEM DES REACTIONS D'APPUI
! OUT LCRIGI  : .TRUE. SI CALCUL DES MATR_ELEM DES MATRICES DE RIGIDITE
! OUT OPTION : NOM D'OPTION PASSE A MERIMO POUR FORCES INTERNES
!
!
!
!
    aster_logical :: reasma
    character(len=16) :: metcor, metpre
    aster_logical :: lunil, lctcd, lreli, lexpl
!
! ----------------------------------------------------------------------
!
    lunil = isfonc(fonact,'LIAISON_UNILATER')
    lctcd = isfonc(fonact,'CONT_DISCRET')
    lreli = isfonc(fonact,'RECH_LINE')
    lexpl = ndynlo(sddyna,'EXPLICITE')
!
! --- CHOIX DE REASSEMBLAGE DE LA MATRICE GLOBALE
!
    call nmchrm('FORCES_INT', ds_algopara, fonact, sddisc, sddyna,&
                numins, iterat, ds_contact, metpre, metcor,&
                reasma)
!
! --- OPTION DE CALCUL
!
    if (reasma) then
        if (metcor .eq. 'TANGENTE') then
            option = 'FULL_MECA'
        else
            option = 'FULL_MECA_ELAS'
        endif
    else
        option = 'RAPH_MECA'
    endif
!
! --- DOIT-ON CALCULER LES VECT_ELEM DES FORCES INTERNES ?
! --- INUTILE SI FULL_MECA (DEJA FAIT)
!
    if (.not.lreli .or. iterat .eq. 0) then
        lcfint = .true.
    else
        if (option .eq. 'FULL_MECA') then
            lcfint = .true.
        else
            lcfint = .false.
        endif
    endif
!
    if (lctcd .or. lunil) then
        lcfint = .true.
    endif
!
    if (lexpl) then
        lcfint = .false.
    endif
!
! --- DOIT-ON CALCULER LES MATR_ELEM DE RIGIDITE ?
!
    if (option .ne. 'RAPH_MECA') then
        lcrigi = .true.
    else
        lcrigi = .false.
    endif
!
! --- DOIT-ON CALCULER LES VECT_ELEM DES REACTIONS D'APPUI ?
!    -> NON SI DEJA CALCULE DANS RECHERCHE LINEAIRE
    lcdiri = lcfint
    lcbudi = lcfint
!
end subroutine
