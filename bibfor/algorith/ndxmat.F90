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

subroutine ndxmat(fonact, lischa, numedd, sddyna, numins,&
                  meelem, measse, matass)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/ascoma.h"
#include "asterfort/detrsd.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtcmbl.h"
#include "asterfort/mtdefs.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmchex.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19) :: matass
    character(len=19) :: sddyna
    integer :: fonact(*)
    integer :: numins
    character(len=19) :: meelem(*), measse(*)
    character(len=24) :: numedd
    character(len=19) :: lischa
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
!
! ASSEMBLAGE DE LA MATRICE GLOBALE - CAS EXPLICITE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDYNA : SD DYNAMIQUE
! IN  NUMINS : NUMERO D'INSTANT
! IN  NUMEDD : NOM DE LA NUMEROTATION MECANIQUE
! IN  LISCHA : SD LISTE DES CHARGES
! IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
! IN  MEELEM : VARIABLE CHAPEAU POUR NOM DES MATR_ELEM
! OUT MATASS : MATRICE ASSEMBLEE RESULTANTE
!
! ----------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_neum_undead, lshima, lprem
    real(kind=8) :: coemas, coeshi
    character(len=8) :: nomddl
    real(kind=8) :: coemat
    character(len=24) :: limat
    character(len=4) :: typcst
    real(kind=8) :: coemam(2)
    character(len=24) :: limam(2)
    character(len=4) :: typcsm(2)
    integer :: nbmat
    character(len=19) :: rigid, masse
!
! ----------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE><CALC> CALCUL MATRICE GLOBALE'
    endif
!
! --- PREMIER PAS DE TEMPS ?
!
    lprem = numins.le.1
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(measse, 'MEASSE', 'MERIGI', rigid)
    call nmchex(measse, 'MEASSE', 'MEMASS', masse)
    nomddl = ' '
!
! --- FONCTIONNALITES ACTIVEES
!
    l_neum_undead = isfonc(fonact,'NEUM_UNDEAD')
    lshima        = ndynlo(sddyna,'COEF_MASS_SHIFT')
!
! --- SUPPRESSION ANCIENNE MATRICE ASSEMBLEE
!
    call detrsd('MATR_ASSE', matass)
!
! --- COEFFICIENTS POUR MATRICES
!
    coemas = ndynre(sddyna,'COEF_MATR_MASS')
    coeshi = ndynre(sddyna,'COEF_MASS_SHIFT')
!
! --- DECALAGE DE LA MATRICE MASSE (COEF_MASS_SHIFT)
!
    if (lshima .and. lprem) then
        typcsm(1) = 'R'
        typcsm(2) = 'R'
        coemam(1) = 1.d0
        coemam(2) = coeshi
        limam(1) = masse
        limam(2) = rigid
        nbmat = 2
        call mtcmbl(nbmat, typcsm, [coemam], limam, masse,&
                    nomddl, ' ', 'ELIM=')
    endif
!
! --- MATRICES ET COEFFICIENTS
!
    typcst = 'R'
    limat = masse
    nbmat = 1
    coemat = coemas
!
! --- DEFINITION DE LA STRUCTURE DE LA MATRICE
!
    call mtdefs(matass, masse, 'V', 'R')
!
! --- ASSEMBLAGE
!
    call mtcmbl(nbmat, typcst, [coemat], limat, matass,&
                nomddl, ' ', 'ELIM=')
!
! --- PRISE EN COMPTE DE LA MATRICE TANGENTE DES FORCES SUIVEUSES
!
    if (l_neum_undead) then
        call ascoma(meelem, numedd, lischa, matass)
    endif
!
end subroutine
