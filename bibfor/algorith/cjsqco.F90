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

subroutine cjsqco(gamma, sig, x, pref, epssig,&
                  i1, s, sii, siirel, cos3ts,&
                  hts, dets, q, qii, qiirel,&
                  cos3tq, htq, detq)
    implicit none
!     CALCUL DE GRANDEURS UTILES
!     ------------------------------------------------------------------
!     IN
!          GAMMA    :  PARAMETRE MATERIAU
!          SIG      :  CONTRAINTES
!          X        :  VARIABLES ECROUI CINE
!          PREF     :  PRESS REF POUR NORMALISATION
!          EPSSIG   :  EPSILON POUR NULLITE DEVIATEUR
!          I1       :  TRACE DU TENSEUR DES CONTRAINTES
!     OUT
!          S        : DEV(SIG)
!          SII      : SQRT(S:S)
!          SIIREL   : SII/PREF
!          COS3TS   : LODE(SIG)
!          HTS      : FONCTION H(TETHA_S)
!          DETS     : DETERMINANT DE S
!
!          Q        : Q(SIG-X)
!          QII      : SQRT(Q:Q)
!          QIIREL   : QII/PREF
!          COS3TQ
!          HTQ      : FONCTION H(TETHA_Q)
!          DETQ     : DETERMINANT DE Q
! ======================================================================
#include "asterfort/cjsqij.h"
#include "asterfort/cos3t.h"
#include "asterfort/hlode.h"
#include "asterfort/lcdete.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lcprsc.h"
    integer :: ndt, ndi
    real(kind=8) :: gamma, pref, epssig
    real(kind=8) :: sig(6), x(6), s(6), q(6)
    real(kind=8) :: i1, sii, siirel, cos3ts, qii, qiirel, cos3tq
    real(kind=8) :: hts, dets, htq, detq
! ======================================================================
    common /tdim/   ndt, ndi
! ======================================================================
! --- CALCUL DES ANGLES DE LODE POUR S ET Q ----------------------------
! ======================================================================
    call lcdevi(sig, s)
    call lcdete(s, dets)
    call lcprsc(s, s, sii)
    sii = sqrt(sii)
    siirel = sii / pref
    cos3ts = cos3t(s, pref, epssig)
!
    call cjsqij(s, i1, x, q)
    call lcdete(q, detq)
    call lcprsc(q, q, qii)
    qii = sqrt(qii)
    qiirel = qii / pref
    cos3tq = cos3t(q, pref, epssig)
! ======================================================================
! --- CALCUL DE HT POUR LES ANGLES DE LODE DE S ET Q -------------------
! ======================================================================
    hts = hlode(gamma,cos3ts)
    htq = hlode(gamma,cos3tq)
! ======================================================================
end subroutine
