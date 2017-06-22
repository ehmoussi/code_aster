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

subroutine nmmajc(fonact, sddyna, sdnume, deltat, numedd,&
                  valinc, solalg)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/majdva.h"
#include "asterfort/mxmajd.h"
#include "asterfort/ndmapp.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nmmaji.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
    integer :: fonact(*)
    character(len=19) :: sdnume, sddyna
    character(len=24) :: numedd
    character(len=19) :: solalg(*), valinc(*)
    real(kind=8) :: deltat
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME )
!
! MISE A JOUR LES CHAMPS SOLUTIONS AVEC INCREMENT SOLUTION ET CONTACT
!
! ----------------------------------------------------------------------
!
!
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  SDNUME : SD NUMEROTATION
! IN  SDDYNA : SD DYNAMIQUE
! IN  NUMEDD : NOM DU NUME_DDL
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  DELTAT : INCREMENT DE TEMPS
!
!
!
!
    aster_logical :: lgrot, ldyna, lstat, lexpl
    aster_logical :: lendo
    aster_logical :: lexge, ltcha, lmuap
    aster_logical :: ldepl, lvite, lacce
    character(len=19) :: depplu, vitplu, accplu, depmoi, vitmoi
    character(len=19) :: depdel, vitdel, accdel
    character(len=19) :: ddepla, dvitla, daccla
    real(kind=8) :: coevit, coefpr
    integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> MISE A JOUR DES INCONNUES'
    endif
!
! --- DECOMPACTION VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPPLU', depplu)
    call nmchex(valinc, 'VALINC', 'VITPLU', vitplu)
    call nmchex(valinc, 'VALINC', 'ACCPLU', accplu)
    call nmchex(valinc, 'VALINC', 'DEPMOI', depmoi)
    call nmchex(valinc, 'VALINC', 'VITMOI', vitmoi)
    call nmchex(solalg, 'SOLALG', 'DEPDEL', depdel)
    call nmchex(solalg, 'SOLALG', 'VITDEL', vitdel)
    call nmchex(solalg, 'SOLALG', 'ACCDEL', accdel)
    call nmchex(solalg, 'SOLALG', 'DDEPLA', ddepla)
    call nmchex(solalg, 'SOLALG', 'DVITLA', dvitla)
    call nmchex(solalg, 'SOLALG', 'DACCLA', daccla)
!
! --- FONCTIONNALITES ACTIVEES
!
    lstat = ndynlo(sddyna,'STATIQUE')
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
    lgrot = isfonc(fonact,'GD_ROTA')
    lexge = ndynlo(sddyna,'EXPL_GENE')
    lexpl = ndynlo(sddyna,'EXPLICITE')
    ltcha = ndynlo(sddyna,'TCHAMWA')
    lendo = isfonc(fonact,'ENDO_NO')
    lmuap = ndynlo(sddyna,'MULTI_APPUI')
!
! --- TYPE DE FORMULATION SCHEMA DYNAMIQUE GENERAL
!
    if (lstat) then
        ldepl = .true.
        lvite = .false.
        lacce = .false.
    else
        ldepl = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.1
        lvite = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.2
        lacce = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.3
    endif
!
! --- MISE A JOUR INCONNUE PRINCIPALE
!
    coefpr = 1.d0
    if (ldepl) then
        if (lstat) then
            call nmmaji(numedd, lgrot, lendo, sdnume, coefpr,&
                        depdel, ddepla, depdel, 0)
            call nmmaji(numedd, lgrot, lendo, sdnume, coefpr,&
                        depplu, ddepla, depplu, 1)
        endif
    else if (lvite) then
        call nmmaji(numedd, lgrot, lendo, sdnume, coefpr,&
                    vitdel, dvitla, vitdel, 0)
        call nmmaji(numedd, lgrot, lendo, sdnume, coefpr,&
                    vitplu, dvitla, vitplu, 1)
    else if (lacce) then
        if (lexpl) then
            call copisd('CHAMP_GD', 'V', daccla, accplu)
        else
            call nmmaji(numedd, lgrot, lendo, sdnume, coefpr,&
                        accdel, daccla, accdel, 0)
            call nmmaji(numedd, lgrot, lendo, sdnume, coefpr,&
                        accplu, daccla, accplu, 1)
        endif
    else
        ASSERT(.false.)
    endif
!
! --- COEFFICIENTS
!
    if (lstat) then
        goto 999
    else
        coevit = ndynre(sddyna,'COEF_VITE')
    endif
!
! ---- MISE A JOUR INCONNUES SECONDAIRES
!
    if (ldepl) then
        if (lgrot) then
            call majdva(numedd, sdnume, sddyna, valinc, solalg)
        else
            call vtaxpy(1.d0, ddepla, depplu)
            call vtaxpy(1.d0, dvitla, vitplu)
            call vtaxpy(1.d0, daccla, accplu)
            call vtaxpy(1.d0, ddepla, depdel)
            call vtaxpy(1.d0, dvitla, vitdel)
            call vtaxpy(1.d0, daccla, accdel)
        endif
    else if (lvite) then
        call vtaxpy(1.d0, ddepla, depplu)
        call vtaxpy(1.d0, daccla, accplu)
        call vtaxpy(1.d0, daccla, accdel)
        call vtzero(depdel)
        call vtaxpy(1.d0, depplu, depdel)
        call vtaxpy(-1.d0, depmoi, depdel)
    else if (lacce) then
        if (lexpl) then
            if (.not.ltcha) then
                call vtaxpy(coevit, accplu, vitplu)
            endif
        else
            call vtaxpy(1.d0, ddepla, depplu)
            call vtaxpy(1.d0, dvitla, vitplu)
        endif
        call vtaxpy(1.d0, ddepla, depdel)
        call vtaxpy(1.d0, dvitla, vitdel)
    else
        ASSERT(.false.)
    endif
!
! --- MISE A JOUR DES DEPL/VITE/ACCE GENERALISEES
!
    if (lexge) then
        call mxmajd(deltat, sddyna)
    endif
!
! --- MISE A JOUR DES CHAMPS MULTI-APPUI
!
    if (lmuap) then
        call ndmapp(sddyna, valinc)
    endif
!
! --- AFFICHAGE
!
999 continue
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ...... DEPPLU : '
        call nmdebg('VECT', depplu, 6)
        write (ifm,*) '<MECANONLINE> ...... DEPDEL : '
        call nmdebg('VECT', depdel, 6)
        if (ldyna) then
            write (ifm,*) '<MECANONLINE> ...... VITPLU : '
            call nmdebg('VECT', vitplu, 6)
            write (ifm,*) '<MECANONLINE> ...... VITDEL : '
            call nmdebg('VECT', vitdel, 6)
            write (ifm,*) '<MECANONLINE> ...... ACCPLU : '
            call nmdebg('VECT', accplu, 6)
            write (ifm,*) '<MECANONLINE> ...... ACCDEL : '
            call nmdebg('VECT', accdel, 6)
        endif
    endif
!
    call jedema()
end subroutine
