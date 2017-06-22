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

subroutine ascarm(nomsy, monoap, nbsup, nsupp, neq,&
                  nbmode, vecmod, momec, id, reasup,&
                  spectr, repmod, corfre, amort, muapde,&
                  tcosup, im, nbdis, nopara, nordr)
    implicit none
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/rsadpa.h"
    integer :: nbsup, nsupp(*), neq, nbmode, id, tcosup(nbsup, *), im, nbdis(*)
    integer :: nordr(*)
    real(kind=8) :: vecmod(neq, *), spectr(*), amort(*)
    real(kind=8) :: repmod(nbsup, neq, *)
    real(kind=8) :: reasup(nbsup, nbmode, *)
    character(len=16) :: nomsy, nopara(*)
    character(len=*) :: momec
    aster_logical :: monoap, corfre, muapde
!     COMMANDE : COMB_SISM_MODAL
!        CALCUL DE LA REPONSE POUR CHAQUE MODE
!     ------------------------------------------------------------------
! IN  : NOMSY  : OPTION DE CALCUL
! IN  : MONOAP : =.TRUE. , CAS DU MONO-APPUI
! IN  : NBSUP  : NOMBRE DE SUPPORT
! IN  : NSUPP  : MAX DU NOMBRE DE SUPPORT PAR DIRECTION
! IN  : NEQ    : NOMBRE D'EQUATIONS
! IN  : NBMODE : NOMBRE DE MODES
! IN  : VECMOD : VECTEUR DES MODES
! IN  : MOMEC : MODES MECANIQUES
! IN  : ID     : DIRECTION
! IN  : REASUP : TABLEAU DES REACTIONS MODALES AUX SUPPORTS
! IN  : SPECTR : TABLEAU DES VALEURS DU SPECTRE
! OUT : REPMOD : VECTEUR DES REPONSES MODALES
! IN  : CORFRE : = .TRUE.  , CORRECTION DES FREQUENCES
! IN  : AMORT  : VECTEUR DES AMORTISSEMENTS MODAUX
! IN  : NBDIS  : APPARTENANCE DES SUPPORTS AUX INTRAGROUPES
!     ------------------------------------------------------------------
    integer :: in, is, ind, ioc, ival
    real(kind=8) :: un, xamo, omega, omega2, xxm, xxx, yyy
!     ------------------------------------------------------------------
!
    un = 1.d0
    call rsadpa(momec, 'L', 1, nopara(1), nordr(im),&
                0, sjv=ival, istop=0)
    omega = sqrt(zr(ival))
    xamo = amort(im)
    if (corfre) omega = omega * sqrt( un - xamo*xamo )
    omega2 = omega * omega
!
!     --- CAS DU MONO-APPUI ---
!
    if (monoap) then
        ind = id + 3*(im-1)
        
        call rsadpa(momec, 'L', 1, nopara(2+id), nordr(im),&
                    0, sjv=ival, istop=0)
        xxx = ( zr(ival) * spectr(ind) ) / omega2
        
        if (nomsy(1:4) .eq. 'VITE') xxx = xxx * omega
        if (nomsy(1:4) .eq. 'ACCE') xxx = xxx * omega2
        do in = 1, neq
            repmod(nbsup,in,id) = xxx * vecmod(in,im)
        enddo
!
!     --- CAS DU MULTI-APPUI ---
!
    else
        do is = 1, nbsup
            do in = 1, neq
                repmod(is,in,id) = 0.d0
            enddo
        enddo
        call rsadpa(momec, 'L', 1, nopara(2), nordr(im),&
                    0, sjv=ival, istop=0)
        xxm = -un / ( zr(ival) * omega2 * omega2 )
        if (nomsy(1:4) .eq. 'VITE') xxm = xxm * omega
        if (nomsy(1:4) .eq. 'ACCE') xxm = xxm * omega2
        do is = 1, nsupp(id)
            ind = id + 3*(im-1) + 3*nbmode*(is-1)
            xxx = reasup(is,im,id) * xxm * spectr(ind)
            do in = 1, neq
                ioc = nbdis(is)
                repmod(ioc,in,id) = repmod(ioc,in,id)+ xxx * vecmod( in,im)
            enddo
        enddo
    endif
!
! --- CAS CORRELE : ON RECOMBINE LES SUPPORTS
!
    if (.not.muapde) then
        do in = 1, neq
            yyy=0.d0
            do is = 1, nsupp(id)
                if (tcosup(is,id) .eq. 1) then
!              --- COMBINAISON QUADRATIQUE ---
                    xxx = repmod(is,in,id)
                    yyy=yyy+sqrt(xxx*xxx)
!
                else if (tcosup(is,id).eq.2) then
!              --- COMBINAISON LINEAIRE ---
                    xxx = repmod(is,in,id)
                    yyy=yyy+xxx
!
                else
!              --- COMBINAISON VALEUR ABSOLUE ---
                    xxx = abs( repmod(is,in,id) )
                    yyy=yyy+xxx
                endif
            enddo
            repmod(1,in,id) = yyy
        enddo
    endif
!
end subroutine
