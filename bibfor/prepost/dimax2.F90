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

subroutine dimax2(jdom, nbpt, cuon, cvon, rayon,&
                  cupn, cvpn, iret)
    implicit   none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: jdom, nbpt, iret
    real(kind=8) :: cuon, cvon, rayon, cupn, cvpn
! person_in_charge: van-xuan.tran at edf.fr
! ---------------------------------------------------------------------
! BUT: PARMI UNE LISTE DE POINTS, DETERMINER LE POINT QUI EST LE PLUS
!      ELOIGNE D'UN POINT DONNE.
! ---------------------------------------------------------------------
! ARGUMENTS :
!     JDOM    : IN  : ADRESSE DU VECTEUR CONTENANT LES POINTS DU
!                     DOMAINE PARMI LESQUELS, NOUS CHERCHONS S'IL
!                     EXISTE UN POINT QUI SOIT PLUS ELOIGNE DU CENTRE
!                     QUE LE RAYON PRECEDEMMENT CALCULE.
!     NBPT    : IN  : NOMBRE DE POINTS DANS LE DOMAINE.
!     CUON    : IN  : COMPOSANTE U DU CENTRE "On".
!     CVON    : IN  : COMPOSANTE V DU CENTRE "On".
!     RAYON   : IN  : VALEUR DU RAYON CIRCONSCRIT AVANT RECHERCHE D'UN
!                     POINT PLUS ELOIGNE DU CENTRE "On".
!     CUPN    : OUT : COMPOSANTE U DU POINT LE PLUS ELOIGNE S'IL EN
!                     EXISTE UN.
!     CVPN    : OUT : COMPOSANTE V DU POINT LE PLUS ELOIGNE S'IL EN
!                     EXISTE UN.
!     IRET    : OUT : INDIQUE S'IL EXISTE UN POINT PLUS ELOIGNE
!                     DU CENTRE "On" QUE DE LA VALEUR DU RAYON
!                     CIRCONSCRIT PRECEDENT.
!                     IRET = 0 => IL N'Y A PAS DE POINT PLUS ELOIGNE;
!                     IRET = 1 => IL Y A AUMOINS UN POINT PLUS ELOIGNE.
!     -----------------------------------------------------------------
!     ------------------------------------------------------------------
    integer :: i
    real(kind=8) :: cui, cvi, ray0, dist, epsilo
!     ------------------------------------------------------------------
!
!234567                                                              012
    call jemarq()
!
    iret = 0
    cupn = 0.0d0
    cvpn = 0.0d0
    ray0 = rayon
    epsilo = 1.0d-4
!
    do 10 i = 1, nbpt
        cui = zr(jdom + (i-1)*2)
        cvi = zr(jdom + (i-1)*2 + 1)
        dist = sqrt((cuon - cui)**2 + (cvon - cvi)**2)
!
        if (dist .gt. (ray0*(1.0d0+epsilo))) then
            ray0 = dist
            cupn = cui
            cvpn = cvi
            iret = 1
        endif
!
10  end do
!
    call jedema()
end subroutine
