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
subroutine nmcere(model         , nume_dof, ds_material, cara_elem    ,&
                  ds_constitutive, list_load, fonact, ds_measure,&
                  iterat         , sdnume, valinc, solalg    , veelem    ,&
                  veasse         , offset, rho   , eta       , residu    ,&
                  ldccvg         , matass)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/majour.h"
#include "asterfort/nmaint.h"
#include "asterfort/nmbudi.h"
#include "asterfort/nmcha0.h"
#include "asterfort/nmchai.h"
#include "asterfort/nmchcp.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmchso.h"
#include "asterfort/nmdiri.h"
#include "asterfort/nmfext.h"
#include "asterfort/nmfint.h"
#include "asterfort/nmpilr.h"
#include "asterfort/nmtime.h"
#include "asterfort/r8inir.h"
#include "blas/daxpy.h"
!
integer :: fonact(*)
integer :: iterat, ldccvg
real(kind=8) :: eta, rho, offset, residu
character(len=19) :: list_load, sdnume, matass
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=24) :: model, nume_dof, cara_elem
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19) :: veelem(*), veasse(*)
character(len=19) :: solalg(*), valinc(*)
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
!
! CHOIX DU ETA DE PILOTAGE PAR CALCUL DU RESIDU
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  SDNUME : SD NUMEROTATION
! IO  ds_measure       : datastructure for measure and statistics management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  OFFSET : DECALAGE DE ETA_PILOTAGE EN FONCTION DE RHO
! IN  RHO    : PARAMETRE DE RECHERCHE_LINEAIRE
! IN  ETA    : PARAMETRE DE PILOTAGE
! IN  SDNUME : SD NUMEROTATION
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
! OUT RESIDU : RESIDU OPTIMAL SI L'ON A CHOISI LE RESIDU
! IN  MATASS : SD MATRICE ASSEMBLEE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: zvalin = 28
    integer, parameter :: zsolal = 17
    aster_logical :: lgrot, lendo
    integer :: neq, nmax
    character(len=24) :: varc_refe, mate
    character(len=19) :: vefint, vediri, vebudi
    character(len=19) :: cnfint, cndiri, cnfext, cnbudi
    character(len=19) :: valint(zvalin)
    character(len=19) :: solalt(zsolal)
    character(len=19) :: depdet, depdel, deppr1, deppr2
    character(len=19) :: depplt, ddep
    character(len=19) :: depplu
    character(len=19) :: sigplu, varplu, complu
    character(len=19) :: depl, vite, acce, k19bla
    real(kind=8), pointer :: ddepl(:) => null()
    real(kind=8), pointer :: depdl(:) => null()
    real(kind=8), pointer :: depdt(:) => null()
    real(kind=8), pointer :: deppl(:) => null()
    real(kind=8), pointer :: deppt(:) => null()
    real(kind=8), pointer :: du0(:) => null()
    real(kind=8), pointer :: du1(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('PILOTAGE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<PILOTAGE> ...... CALCUL DU RESIDU'
    endif
!
! --- INITIALISATIONS
!
    mate      = ds_material%field_mate
    varc_refe = ds_material%varc_refe
    k19bla = ' '
    lgrot = isfonc(fonact,'GD_ROTA')
    lendo = isfonc(fonact,'ENDO_NO')
    ddep = '&&CNCETA.CHP0'
    depdet = '&&CNCETA.CHP1'
    depplt = '&&CNCETA.CHP2'
    ldccvg = -1
    call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi=neq)
    call nmchai('VALINC', 'LONMAX', nmax)
    ASSERT(nmax.eq.zvalin)
    call nmchai('SOLALG', 'LONMAX', nmax)
    ASSERT(nmax.eq.zsolal)
!
! --- DECOMPACTION VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPPLU', depplu)
    call nmchex(valinc, 'VALINC', 'SIGPLU', sigplu)
    call nmchex(valinc, 'VALINC', 'VARPLU', varplu)
    call nmchex(valinc, 'VALINC', 'COMPLU', complu)
    call nmchex(solalg, 'SOLALG', 'DEPDEL', depdel)
    call nmchex(solalg, 'SOLALG', 'DEPPR1', deppr1)
    call nmchex(solalg, 'SOLALG', 'DEPPR2', deppr2)
    call nmchex(veelem, 'VEELEM', 'CNDIRI', vediri)
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nmchex(veelem, 'VEELEM', 'CNFINT', vefint)
    call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(veelem, 'VEELEM', 'CNBUDI', vebudi)
    call nmchex(veasse, 'VEASSE', 'CNBUDI', cnbudi)
!
! --- MISE A JOUR DEPLACEMENT
! --- DDEP = RHO*DEPPRE(1) + (ETA-OFFSET)*DEPPRE(2)
!
    call jeveuo(deppr1(1:19)//'.VALE', 'L', vr=du0)
    call jeveuo(deppr2(1:19)//'.VALE', 'L', vr=du1)
    call jeveuo(ddep(1:19) //'.VALE', 'E', vr=ddepl)
    call r8inir(neq, 0.d0, ddepl, 1)
    call daxpy(neq, rho, du0, 1, ddepl, 1)
    call daxpy(neq, eta-offset, du1, 1, ddepl, 1)
!
! --- MISE A JOUR DE L'INCREMENT DE DEPLACEMENT DEPUIS LE DEBUT
! --- DU PAS DE TEMPS DEPDET = DEPDEL+DDEP
!
    call jeveuo(depdel(1:19)//'.VALE', 'L', vr=depdl)
    call jeveuo(depdet(1:19)//'.VALE', 'E', vr=depdt)
    call majour(neq, lgrot, lendo, sdnume, depdl,&
                ddepl, 1.d0, depdt, 0)
!
! --- MISE A JOUR DU DEPLACEMENT DEPPLT = DEPPLU+DDEP
!
    call jeveuo(depplu(1:19)//'.VALE', 'L', vr=deppl)
    call jeveuo(depplt(1:19)//'.VALE', 'E', vr=deppt)
    call majour(neq, lgrot, lendo, sdnume, deppl,&
                ddepl, 1.d0, deppt, 1)
!
! --- RECONSTRUCTION DES VARIABLES CHAPEAUX
!
    call nmcha0('VALINC', 'ALLINI', ' ', valint)
    call nmchcp('VALINC', valinc, valint)
    call nmcha0('VALINC', 'DEPPLU', depplt, valint)
    call nmchso(solalg, 'SOLALG', 'DEPDEL', depdet, solalt)
    call nmchex(valint, 'VALINC', 'DEPPLU', depl)
    call nmchex(valint, 'VALINC', 'VITPLU', vite)
    call nmchex(valint, 'VALINC', 'ACCPLU', acce)
!
! --- REACTUALISATION DES FORCES INTERIEURES
!
    call nmfint(model, mate  , cara_elem, varc_refe , ds_constitutive,&
                fonact, iterat, k19bla, ds_measure, valint         ,&
                solalt, ldccvg, vefint)
!
! --- ASSEMBLAGE DES FORCES INTERIEURES
!
    call nmaint(nume_dof, fonact, veasse, vefint,&
                cnfint, sdnume)
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! - Update force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nmdiri(model, ds_material, cara_elem, list_load,&
                depl , vediri     , nume_dof , cndiri   )
!
! --- REACTUALISATION DES CONDITIONS DE DIRICHLET B.U
!
    call nmbudi(model, nume_dof, list_load, depplt, vebudi,&
                cnbudi, matass)
!
! --- REACTUALISATION DES EFFORTS EXTERIEURS (AVEC ETA)
!
    call nmchex(veasse, 'VEASSE', 'CNFEXT', cnfext)
    call nmfext(eta, fonact, k19bla, veasse, cnfext)
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
! --- ON A FORCEMENT INTEGRE LA LDC !
!
    ASSERT(ldccvg.ge.0)
!
! --- CALCUL DU RESIDU
!
    if (ldccvg .eq. 0) then
        call nmpilr(fonact, nume_dof, matass, veasse, residu,&
                    eta)
    endif
!
end subroutine
