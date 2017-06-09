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

subroutine nminma(fonact, lischa, sddyna, numedd, ds_algopara,&
                  numfix, meelem, measse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmassm.h"
#include "asterfort/nmchex.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: fonact(*)
    character(len=19) :: lischa, sddyna
    character(len=24) :: numedd, numfix
    character(len=19) :: meelem(*), measse(*)
    type(NL_DS_AlgoPara), intent(in) :: ds_algopara
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! PRE-CALCUL DES MATRICES ASSEMBLEES CONSTANTES AU COURS DU CALCUL
!
! ----------------------------------------------------------------------
!
!
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  LISCHA : LISTE DES CHARGEMENTS
! IN  SDDYNA : SD DYNAMIQUE
! IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
! In  ds_algopara      : datastructure for algorithm parameters
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! IN  MEELEM : MATRICES ELEMENTAIRES
! OUT MEASSE : MATRICES ASSEMBLEES
!
! ----------------------------------------------------------------------
!
    aster_logical :: ldyna, lexpl, limpl, lamor, lktan
    integer :: ifm, niv
    character(len=16) :: optass
    character(len=19) :: masse, amort
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> PRECALCUL DES MATR_ASSE CONSTANTES'
    endif
!
! --- INITIALISATIONS
!
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
    lexpl = ndynlo(sddyna,'EXPLICITE')
    limpl = ndynlo(sddyna,'IMPLICITE')
    lamor = ndynlo(sddyna,'MAT_AMORT')
    lktan = ndynlo(sddyna,'RAYLEIGH_KTAN')
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(measse, 'MEASSE', 'MEMASS', masse)
    call nmchex(measse, 'MEASSE', 'MEAMOR', amort)
!
! --- ASSEMBLAGE DE LA MATRICE MASSE
!
    if (ldyna) then
        if (limpl) then
            optass = ' '
        else if (lexpl) then
            optass = 'AVEC_DIRICHLET'
        else
            ASSERT(.false.)
        endif
        if (niv .ge. 2) then
            write (ifm,*) '<MECANONLINE> ... MATR_ASSE DE MASSE'
        endif
        call nmassm(fonact, lischa, numedd, numfix, ds_algopara,&
                    'MEMASS', optass, meelem, masse)
    endif
!
! --- ASSEMBLAGE DE LA MATRICE AMORTISSEMENT
!
    if (lamor .and. .not.lktan) then
        if (niv .ge. 2) then
            write (ifm,*) '<MECANONLINE> ... MATR_ASSE AMORTISSEMENT'
        endif
        optass = ' '
        call nmassm(fonact, lischa,  numedd, numfix, ds_algopara,&
                    'MEAMOR', optass, meelem, amort)
    endif
!
    call jedema()
end subroutine
