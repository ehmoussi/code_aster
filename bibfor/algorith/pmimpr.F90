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

subroutine pmimpr(ind, inst, indimp, fonimp, valimp,&
                  iter, eps, sig, vi, nbvari,&
                  r, ee, eini)
! person_in_charge: jean-michel.proix at edf.fr
!-----------------------------------------------------------------------
!     OPERATEUR CALC_POINT_MAT : IMPRESSIONS DE NIVEAU 2
!-----------------------------------------------------------------------
! IN  IND    : 0 pour l'état initial
!                1 pour l'itaration courante
!                2 pour la convergence
!                3 pour l'erreur relative
!                4 pour l'erreur absolue
! IN  INST   : INSTANT ACTUEL
! IN  FONIMP : FONCTIONS IMPOSEES POUR EPSI OU SIGM
! IN  VALIMP : VALEUR DE LA CMP DE EPSI OU SIGM IMPOSEE
! IN  ITER   : NUMERO D'ITERATION
! IN  EPS    : DEFORMATIONS
! IN  SIG    : CONTRAINTES
! IN  VI     : VARIABLES INTERNES
! IN  NBVARI : Nombre de variables internes
! IN  R      : RESIDU ACTUEL
! IN  EE     : ERREUR
! IN  EINI   : ERREUR INITIALE
!-----------------------------------------------------------------------
    implicit none
#include "asterfort/infniv.h"
    integer :: nbvari, niv, ifm, ind, i, iter, idbg, indimp(6)
    real(kind=8) :: inst, valimp(6), eps(6), sig(6), vi(nbvari), r(12), ee, eini
    character(len=8) :: fonimp(6)
    character(len=4) :: nomeps(6), nomsig(6)
    data nomeps/'EPXX','EPYY','EPZZ','EPXY','EPXZ','EPYZ'/
    data nomsig/'SIXX','SIYY','SIZZ','SIXY','SIXZ','SIYZ'/
!-----------------------------------------------------------------------
!
    call infniv(ifm, niv)
    idbg=0
!
    if (niv .lt. 2) goto 9999
!
    if (ind .eq. 0) then
        write(ifm,*) ' '
        write(ifm,*) ' ==============================================='
        write(ifm,*) 'INST',inst
        do 151 i = 1, 6
            if (valimp(i) .ne. 0.d0) then
                if (indimp(i) .eq. 0) then
                    write(ifm,*) nomsig(i),' IMPOSEE =',valimp(i)
                else if (indimp(i).eq.1) then
                    write(ifm,*) nomeps(i),' IMPOSEE =',valimp(i)
                endif
            endif
151      continue
        if (idbg .eq. 1) then
            write(ifm,*) ' ETAT INITIAL '
            write(ifm,'(1X,A4,6(1X,E12.5))') 'EPSM',eps
            write(ifm,'(1X,A4,6(1X,E12.5))') 'SIGM',sig
            write(ifm,'(1X,A4,6(1X,E12.5))') 'VIM', (vi(i),i=1,min(6,&
            nbvari))
            if (nbvari .gt. 6) then
                write(ifm,'(1X,A4,6(1X,E12.5))')'   ',(vi(i),i=7, nbvari)
            endif
            write(ifm,'(1X,A4,6(1X,E12.5))')'RESI',r
        endif
    else if (ind.eq.1) then
        if (idbg .eq. 1) then
            write(ifm,*) '  '
            write(ifm,*) ' ITERATION',iter
            write(ifm,*) ' '
            write(ifm,'(1X,A4,6(1X,E12.5))') 'EPS',eps
            write(ifm,'(1X,A4,6(1X,E12.5))') 'SIG',sig
            write(ifm,'(1X,A4,6(1X,E12.5))')'VAR', (vi(i),i=1,min(6,&
            nbvari))
            if (nbvari .gt. 6) then
                write(ifm,'(5X,6(1X,E12.5))')(vi(i),i=7,nbvari)
            endif
            write(ifm,'(1X,A4,6(1X,E12.5))')'RESI',r
        endif
    else if (ind.eq.2) then
        if (idbg .eq. 1) then
            write(ifm,*) '  '
            write(ifm,*) ' ==============================================='
            write(ifm,*) ' CONVERGENCE ITERATION ',iter
            write(ifm,*) ' ==============================================='
            write(ifm,*) ' '
            write(ifm,'(1X,A4,6(1X,E12.5))') 'EPS',eps
            write(ifm,'(1X,A4,6(1X,E12.5))') 'SIG',sig
            write(ifm,'(1X,A4,6(1X,E12.5))')'VAR',(vi(i),i=1,min(6,&
            nbvari))
            if (nbvari .gt. 6) then
                write(ifm,'(1X,A4,6(1X,E12.5))')'   ',(vi(i),i=7, nbvari)
            endif
            write(ifm,'(1X,A4,6(1X,E12.5))')'RESI',r
            write(ifm,*) ' '
            write(ifm,*) ' ==============================================='
        endif
    else if (ind.eq.4) then
        write(ifm,*) ' -------------------------------------'
        write(ifm,'(1X,A4,E12.5,1X,A4,I5,1X,A7,E12.5)') 'INST',inst,&
        'ITER',iter,'ERR_ABS',ee
    else if (ind.eq.3) then
        write(ifm,*) ' -----------------------------------------------'
        write(ifm,'(1X,A4,E12.5,1X,A4,I5,1X,A12,E12.5,1X,A14,E12.5)')&
        'INST',inst,'ITER',iter,'ERR.RELATIVE',ee,'RESIDU INITIAL',&
        eini
    endif
!
9999  continue
end subroutine
