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

subroutine sigmca(tablca, carsig, icabl, nbnoca, numaca,&
                  quad)
    implicit none
!  DESCRIPTION : MISE A JOUR DE LA CARTE ELEMENTAIRE DES CONTRAINTES
!  -----------   INITIALES POUR LE CABLE COURANT
!                APPELANT : OP0180 , OPERATEUR DEFI_CABLE_BP
!
!  IN     : TABLCA : CHARACTER*19
!                    NOM DE LA TABLE DECRIVANT LES CABLES
!  IN     : CARSIG : CHARACTER*19 , SCALAIRE
!                    NOM DE LA CARTE ELEMENTAIRE DES CONTRAINTES
!                    INITIALES
!  IN     : ICABL  : INTEGER , SCALAIRE
!                    NUMERO DU CABLE
!  IN     : NBNOCA : INTEGER , VECTEUR DE DIMENSION NBCABL
!                    CONTIENT LES NOMBRES DE NOEUDS DE CHAQUE CABLE
!  IN     : NUMACA : CHARACTER*19 , SCALAIRE
!                    NOM D'UN VECTEUR D'ENTIERS POUR STOCKAGE DES
!                    NUMEROS DES MAILLES APPARTENANT AUX CABLES
!  IN     : QUAD   : VRAI SI MAILLAGE QUADRATIQUE (SEG3)
!
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
!
! ARGUMENTS
! ---------
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
    aster_logical :: quad
    character(len=19) :: carsig, numaca, tablca
    integer :: icabl, nbnoca(*)
!
! VARIABLES LOCALES
! -----------------
    integer :: idecma, idecno, imail, ipara, jnumac, jtens, nblign, nbmaca
    integer :: nbno, nbpara, numail, nbma, mma
    character(len=24) :: tens
    real(kind=8) :: rtens
    aster_logical :: trouve
!
    character(len=24) :: parcr
    real(kind=8), pointer :: valv(:) => null()
    integer, pointer :: tbnp(:) => null()
    character(len=24), pointer :: tblp(:) => null()
    data          parcr /'TENSION                 '/
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
    call jemarq()
!
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
! 1   ACCES AUX DONNEES ET AUX RESULTATS DE CALCUL UTILES
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!
    nbno = nbnoca(icabl)
!
! 1.1 RECUPERATION DE LA TENSION LE LONG DES CABLES
! ---
    call jeveuo(tablca//'.TBNP', 'L', vi=tbnp)
    nbpara = tbnp(1)
    nblign = tbnp(2)
    call jeveuo(tablca//'.TBLP', 'L', vk24=tblp)
    trouve = .false.
    do ipara = 1, nbpara
        if (tblp(1+4*(ipara-1)) .eq. parcr) then
            trouve = .true.
            tens = tblp(1+4*(ipara-1)+2)
            call jeveuo(tens, 'L', jtens)
        endif
        if (trouve) goto 11
    end do
 11 continue
    idecno = nblign - nbno
!
! 1.2 NUMEROS DES MAILLES APPARTENANT AUX CABLES
! ---
    call jelira(numaca, 'LONUTI', nbmaca)
    call jeveuo(numaca, 'L', jnumac)
    if (quad) then
        ASSERT((mod(nbno-1, 2).eq.0))
        nbma=(nbno-1)/2
        mma = 2
    else
        nbma = nbno-1
        mma = 1
    endif
    idecma = nbmaca - nbma
!
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
! 2   MISE A JOUR DE LA CARTE DES CONTRAINTES INITIALES AUX ELEMENTS
!     DES CABLES
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!
!.... BOUCLE SUR LE NOMBRE DE MAILLES DU CABLE COURANT
!
    call jeveuo(carsig//'.VALV', 'E', vr=valv)
    do imail = 1, nbma
        numail = zi(jnumac+idecma+imail-1)
        rtens = ( zr(jtens+idecno+mma*imail-mma) + zr(jtens+idecno+ mma*imail) ) / 2.0d0
        valv(1)=rtens
        valv(2)=0.d0
        valv(3)=0.d0
        call nocart(carsig, 3, 3, mode='NUM', nma=1,&
                    limanu=[numail])
    end do
!
    call jedema()
!
! --- FIN DE SIGMCA.
end subroutine
