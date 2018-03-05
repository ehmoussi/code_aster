! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmnpas(modele    , noma  , fonact,&
                  ds_print  , sddisc, sdsuiv, sddyna    , sdnume    ,&
                  ds_measure, numedd, numins, ds_contact, &
                  valinc    , solalg, solveu, ds_conv   , lischa    )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterc/r8vide.h"
#include "asterfort/copisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/initia.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/cldual_maj.h"
#include "asterfort/cont_init.h"
#include "asterfort/ndnpas.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmimin.h"
#include "asterfort/nmnkft.h"
#include "asterfort/nmvcle.h"
#include "asterfort/SetResi.h"
!
integer :: fonact(*)
character(len=8) :: noma
character(len=19) :: sddyna, sdnume, sddisc, solveu
character(len=24) :: modele
integer :: numins
type(NL_DS_Print), intent(inout) :: ds_print
character(len=24) :: sdsuiv
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: numedd
type(NL_DS_Contact), intent(inout) :: ds_contact
character(len=19) :: solalg(*), valinc(*)
type(NL_DS_Conv), intent(inout) :: ds_conv
character(len=19), intent(in) :: lischa
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! New time step
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  NOMA   : NOM DU MAILLAGE
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  NUMEDD : NUME_DDL
! IN  NUMINS : NUMERO INSTANT COURANT
! IO  ds_print         : datastructure for printing parameters
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  SDSUIV : SD SUIVI_DDL
! IN  SDNUME : NOM DE LA SD NUMEROTATION
! IO  ds_contact       : datastructure for contact management
! IN  SDDYNA : SD DYNAMIQUE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IO  ds_conv          : datastructure for convergence management
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lgrot, ldyna, lnkry
    aster_logical :: l_cont, l_cont_cont, l_diri_undead
    integer :: neq
    character(len=19) :: depmoi, varmoi
    character(len=19) :: depplu, varplu
    character(len=19) :: depdel
    integer :: jdepde
    integer :: indro
    integer :: iterat
    real(kind=8), pointer :: depp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
!
! - Active functionnalites
!
    ldyna         = ndynlo(sddyna,'DYNAMIQUE')
    l_cont        = isfonc(fonact,'CONTACT')
    lgrot         = isfonc(fonact,'GD_ROTA')
    lnkry         = isfonc(fonact,'NEWTON_KRYLOV')
    l_cont_cont   = isfonc(fonact,'CONT_CONTINU')
    l_diri_undead = isfonc(fonact,'DIRI_UNDEAD')
!
! --- POUTRES EN GRANDES ROTATIONS
!
    if (lgrot) then
        call jeveuo(sdnume(1:19)//'.NDRO', 'L', indro)
    else
        indro = isnnem()
    endif
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', depmoi)
    call nmchex(valinc, 'VALINC', 'VARMOI', varmoi)
    call nmchex(valinc, 'VALINC', 'DEPPLU', depplu)
    call nmchex(valinc, 'VALINC', 'VARPLU', varplu)
    call nmchex(solalg, 'SOLALG', 'DEPDEL', depdel)
!
! --- ESTIMATIONS INITIALES DES VARIABLES INTERNES
!
    call copisd('CHAMP_GD', 'V', varmoi, varplu)
!
! --- INITIALISATION DES DEPLACEMENTS
!
    call copisd('CHAMP_GD', 'V', depmoi, depplu)
!
! - Initializations of residuals
!
    call SetResi(ds_conv, vale_calc_ = r8vide())
!
! --- INITIALISATION DE L'INCREMENT DE DEPLACEMENT DEPDEL
!
    call jeveuo(depdel//'.VALE', 'E', jdepde)
    call jeveuo(depplu//'.VALE', 'L', vr=depp)
    call initia(neq, lgrot, zi(indro), depp, zr(jdepde))
!
! - Update dualized relations for non-linear Dirichlet boundary conditions (undead)
!
    if (l_diri_undead) then
        call cldual_maj(lischa, depmoi)
    endif
!
! --- INITIALISATIONS EN DYNAMIQUE
!
    if (ldyna) then
        call ndnpas(fonact, numedd, numins, sddisc, sddyna,&
                    valinc, solalg)
    endif
!
! --- NEWTON-KRYLOV : COPIE DANS LA SD SOLVEUR DE LA PRECISION DE LA
!                     RESOLUTION POUR LA PREDICTION (FORCING-TERM)
    if (lnkry) then
        iterat=-1
        call nmnkft(solveu, sddisc, iterat)
    endif
!
! - Initializations of contact for current time step
!
    if (l_cont) then
        call cont_init(noma  , modele, ds_contact, numins, ds_measure,&
                       sddyna, valinc, sdnume    , fonact)
    endif
!
! - Print management - Initializations for new step time
!
    call nmimin(fonact, sddisc, sdsuiv, numins, ds_print)
!
end subroutine
