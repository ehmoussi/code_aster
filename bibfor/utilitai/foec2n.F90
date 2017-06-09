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

subroutine foec2n(iuni, vecpro, valpar, chval, nbfonc,&
                  impr)
    implicit none
#include "jeveux.h"
!
#include "asterfort/foec2f.h"
#include "asterfort/fopro1.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: iuni, nbfonc, impr
    real(kind=8) :: valpar(nbfonc)
    character(len=*) :: vecpro(*), chval
!     ECRITURE DES VALEURS (PARAMETRE, FONCTION) D'UNE NAPPE,
!     DE LA N1-IEME A LA N2-IEME
!     ------------------------------------------------------------------
! IN  IUNI  : NUMERO D'UNITE LOGIQUE D'ECRITURE
! IN  VECPRO: VECTEUR DE DESCRIPTION DE LA NAPPE
! IN  VALPAR: VECTEUR DES VALEURS DES PARAMETRES
! IN  CHVAL : NOM JEVEUX DE LA COLLECTION DES VALEURS
! IN  NBFONC: NOMBRE DE FONCTIONS
!     ------------------------------------------------------------------
! LOC    N1, N2: NUMEROS DE DEBUT ET FIN DE LA LISTE
!     OBJETS SIMPLES LUS:
!        JEXNUM(CHVAL,I)
!     ------------------------------------------------------------------
!
!     ------------------------------------------------------------------
    integer :: n1, n2, jv, n
    character(len=8) :: nompan, nomres, nompaf
    character(len=8) :: tprol(3), prolgd, interp
!-----------------------------------------------------------------------
    integer :: i, ik, j, k, lf, lfon, lr
    integer :: lvar, n0, ndom, nf1, nf2, nn, npas
!
!-----------------------------------------------------------------------
    data tprol/'CONSTANT','LINEAIRE','EXCLU'/
!
    call jemarq()
    nompaf = vecpro(7)
    nompan = vecpro(3)
    nomres = vecpro(4)
    n1 = min( 1,nbfonc)
    n2 = min(10,nbfonc)
    if (impr .ge. 3) n2=nbfonc
!
!     --- NAPPE DONT LES FONCTIONS SONT DEFINIES AUX MEME INSTANTS ? ---
    ndom = 1
    call jelira(jexnum(chval, n1), 'LONMAX', n0)
    call jeveuo(jexnum(chval, n1), 'L', lr)
    do 10 i = n1+1, n2
        call jelira(jexnum(chval, i), 'LONMAX', n)
        if (n0 .ne. n) then
            ndom = ndom + 1
            goto 12
        else
            call jeveuo(jexnum(chval, i), 'L', lf)
            do 11 j = 0, n/2 - 1
                if (zr(lf+j) .ne. zr(lr+j)) then
                    ndom = ndom + 1
                    goto 12
                endif
11          continue
        endif
10  end do
12  continue
!
!
    if (ndom .eq. 1 .and. n1 .ne. n2) then
        n = n/2
        nf1 = 1
        nf2 = min(10,n)
        if (impr .ge. 3) nf2=n
        npas = 5
        call jeveuo(jexnum(chval, 1), 'L', lvar)
        lfon = lvar + n
        do 100 i = n1, n2, npas
            nn = min(i+npas-1,n2)
            write( iuni,'(/,1X,A8,4X,9(1X,1PE12.5),1X)' ) nompan,&
            ( valpar(k) , k=i,nn )
            write( iuni,'(1X,A)' ) nompaf
            do 110 ik = nf1, nf2
                write(iuni,'(1X,1PE12.5,9(1X,1PE12.5))') zr(lvar+ik-1)&
                , ( zr(lfon+(j-1)*2*n+ik-1) , j=i,nn )
110          continue
100      continue
!
    else
!
        do 200 i = n1, n2
            write(iuni,'(///)' )
            write(iuni,*) ' FONCTION NUMERO: ',i
            write(iuni,*) '    PARAMETRE : ',nompan,' = ',valpar(i)
            call fopro1(vecpro, i, prolgd, interp)
            write(iuni,*) '    INTERPOLATION         : ',interp
            do 210 j = 1, 3
                if (prolgd(1:1) .eq. tprol(j)(1:1)) then
                    write(iuni,*) '    PROLONGEMENT A GAUCHE : ',tprol(j)
                endif
                if (prolgd(2:2) .eq. tprol(j)(1:1)) then
                    write(iuni,*) '    PROLONGEMENT A DROITE : ',tprol(j)
                endif
210          continue
            call jeveuo(jexnum(chval, i), 'L', jv)
            call jelira(jexnum(chval, i), 'LONMAX', n)
            n = n/2
            nf1 = 1
            nf2 = min(10,n)
            if (impr .ge. 3) nf2=n
            call foec2f(iuni, zr(jv), n, nf1, nf2,&
                        nompaf, nomres)
200      continue
    endif
    call jedema()
end subroutine
